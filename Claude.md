# CLAUDE.md — منصة الدواء (Pharmacy Platform)

## نبذة عن المشروع

منصة تربط المرضى بشبكة صيدليات متعاقدة عبر:
- تطبيق Flutter للمرضى (patient app)
- نظام ويب للصيدليات (pharmacy dashboard — Filament)
- تطبيق Flutter للصيدليات (pharmacy mobile — للإشعارات والقبول السريع)
- لوحة تحكم Admin (Filament — لإدارة الكتالوج والتحقق والعمليات)
- Backend Laravel API واحد يخدم الكل

الـ Core value proposition: المريض يلاقي الدوا النادر اللي مش موجود في صيدليته القريبة عبر شبكة صيدليات موزعة جغرافياً، مع توصيل door-to-door.

---

## Stack التقني

| الطبقة | التقنية |
|---|---|
| Backend API | Laravel (PHP) — Modular Monolith |
| Auth | Laravel Sanctum (tokens للموبايل، session للويب) |
| Database | MySQL مع Spatial indexes للاستعلامات الجغرافية |
| Queue & Jobs | Redis + Laravel Horizon |
| Real-time (Web) | Laravel Reverb (WebSockets self-hosted) |
| Push Notifications | FCM (Firebase Cloud Messaging) |
| Search | Laravel Scout + Meilisearch |
| Admin & Pharmacy Web | Filament v3 (multi-panel) |
| Patient Mobile App | Flutter |
| Pharmacy Mobile App | Flutter (خفيف — إشعارات + قبول/رفض) |
| Delivery | Bosta API أو Mylerz API (TBD — مبني كـ abstraction layer) |
| Payments | Paymob |
| Caching | Redis |

---

## بنية المشروع (Laravel Modules)

```
app/
├── Modules/
│   ├── Catalog/          # الكتالوج الموحد للأدوية
│   ├── Pharmacy/         # الصيدليات والمخزون
│   ├── Patient/          # المرضى وعناوينهم
│   ├── Order/            # الطلبات ودورة حياتها
│   ├── Dispatch/         # منطق التوزيع Tiered Dispatch
│   ├── Delivery/         # Abstraction layer للتوصيل
│   ├── Payment/          # Paymob integration
│   └── Notification/     # FCM + Reverb
├── filament/
│   ├── AdminPanel/       # لوحة تحكم الإدارة
│   └── PharmacyPanel/    # لوحة تحكم الصيدلية (ويب)
```

---

## Database Schema

### جدول `drugs` (الكتالوج الموحد)
```sql
id, name_en, name_ar, scientific_name, category_id,
manufacturer, form (tablet/syrup/injection/...),
strength, unit, barcode (nullable — crowdsourced),
price_egp, requires_prescription (bool),
is_scheduled (bool — أدوية الجدول ممنوع توصيلها),
status (enum: verified, unverified, rejected),
verified_by (admin user id), verified_at,
source (enum: initial_import, pharmacy_request, admin),
created_at, updated_at
```

### جدول `drug_categories`
```sql
id, name_ar, name_en, parent_id (nullable — للتصنيف الهرمي), icon
```

### جدول `pharmacies`
```sql
id, name, owner_name, license_number,
address, city, district,
lat, lng (للاستعلامات الجغرافية — SPATIAL INDEX),
phone, whatsapp,
has_delivery (bool), delivery_radius_km,
acceptance_rate (float — يُحسب تلقائياً),
inventory_accuracy_rate (float — يُحسب تلقائياً),
reputation_score (float — مجمّع),
status (enum: pending, active, suspended),
created_at, updated_at
```

### جدول `pharmacy_stock`
```sql
id, pharmacy_id, drug_id,
quantity, last_updated_at,
updated_by (pharmacy user id),
INDEX(pharmacy_id, drug_id)
```

### جدول `pharmacy_users`
```sql
id, pharmacy_id, name, phone, email,
password, role (enum: owner, pharmacist),
fcm_token (للإشعارات على موبايل الصيدلي),
created_at, updated_at
```

### جدول `patients`
```sql
id, name, phone, email (nullable),
created_at, updated_at
```

### جدول `patient_addresses`
```sql
id, patient_id, label (بيت/شغل/...),
address_line, city, district,
lat, lng, is_default (bool)
```

### جدول `orders`
```sql
id, patient_id, drug_id,
patient_address_id, pharmacy_id (null حتى القبول),
status (enum: searching, accepted, preparing,
        picked_up, on_the_way, delivered,
        cancelled, failed),
requires_prescription (bool),
prescription_image (nullable),
cod_amount, delivery_fee, platform_fee,
payment_method (enum: cod, card),
payment_status (enum: pending, paid, refunded),
dispatch_radius_km (يتوسع تدريجياً),
dispatch_attempts (int),
accepted_at, picked_up_at, delivered_at,
delivery_tracking_number (من Bosta/Mylerz),
notes,
created_at, updated_at
```

### جدول `order_pharmacy_broadcasts`
```sql
id, order_id, pharmacy_id,
status (enum: pending, accepted, rejected, expired),
sent_at, responded_at
```

### جدول `delivery_logs`
```sql
id, order_id, event, payload (JSON),
source (enum: bosta, mylerz, manual),
created_at
```

### جدول `drug_addition_requests`
```sql
id, pharmacy_id, requested_drug_name,
barcode (nullable), notes,
status (enum: pending, approved, rejected),
admin_notes, processed_by, processed_at,
created_at
```

---

## Tiered Dispatch Flow

لما مريض يطلب دوا:

```
1. ابحث في pharmacy_stock عن الصيدليات اللي drug_id موجود فيها
   وقريبة من patient_address بدايةً بـ 3 كم

2. رتّبهم بـ:
   - distance (الأقرب أولاً)
   - reputation_score (الأعلى أولاً في نفس الـ tier)

3. ابعت broadcast لأقرب 3-5 صيدليات:
   - سجّل في order_pharmacy_broadcasts (status: pending)
   - ابعت FCM notification للصيدلي على موبايله
   - شغّل delayed job (2 دقيقة timeout)

4. لو مفيش قبول في 2 دقيقة:
   - وسّع الـ radius لـ 7 كم
   - كرّر العملية

5. لو مفيش قبول لحد 15 كم:
   - ابعت Broadcast عام لكل الصيدليات القريبة
     (حتى اللي مخزونها مش معلّم)
   - بتبقى حالة "دوا نادر"

6. لما صيدلية تقبل:
   - UPDATE orders SET pharmacy_id = ? 
     WHERE id = ? AND pharmacy_id IS NULL
   - لو affected_rows = 0 ← صيدلية تانية سبقتها → ignore
   - لو affected_rows = 1 ← هي اللي كسبت الأوردر
   - cancel باقي الـ broadcasts

7. بعد القبول:
   - لو الصيدلية عندها ديليفري ومسافة مناسبة → هي توصّل
   - لو لأ → call Delivery Service (Bosta/Mylerz)
```

---

## Delivery Abstraction Layer

**مهم جداً:** كل integration مع شركات التوصيل يكون خلف Interface واحد:

```php
interface DeliveryServiceInterface {
    public function createShipment(Order $order, Pharmacy $pharmacy): DeliveryResult;
    public function trackShipment(string $trackingNumber): TrackingStatus;
    public function cancelShipment(string $trackingNumber): bool;
}

class BostaDeliveryService implements DeliveryServiceInterface { ... }
class MylerzDeliveryService implements DeliveryServiceInterface { ... }
```

الـ config بيحدد الـ default provider، وأي وقت نغيره من غير ما نلمس باقي الكود.

**Bosta:** الـ pickup address بييجي per-order عبر raw HTTP (Guzzle) مش الـ SDK الرسمي — لأن الـ SDK بيقبل business location فقط.

**Mylerz:** Service type = Domestic & Express (تم التسجيل). API details تتعبّى بعد التواصل مع الـ sales team.

---

## Payment Flow (Paymob)

```
1. Patient يختار الدفع بالكارت
2. Backend يطلب payment_key من Paymob API
3. Flutter يفتح Paymob iframe/webview
4. Paymob يبعت webhook للـ backend بنتيجة الدفع
5. Backend يحدّث payment_status في orders
6. لو COD: المبلغ بيتحصّل عند التسليم عبر كاشير الديليفري
```

---

## Admin Panel (Filament) — المرحلة الأولى

### الفيتشرز الأساسية فقط:

**Drug Catalog Management:**
- قائمة بكل الأدوية مع filter بـ status (verified / unverified / rejected)
- كل دوا بيظهر: الاسم (عربي/إنجليزي)، التركيب العلمي، الفئة، السعر، البار كود
- زرار "Verify" يحوّل الدوا لـ verified بعد مراجعة الفريق على موقع هيئة الدواء
- زرار "Reject" مع سبب الرفض
- إمكانية تعديل البيانات الغلط مباشرة
- سيرش سريع بالاسم العربي أو الإنجليزي أو التركيب العلمي

**Drug Addition Requests (من الصيدليات):**
- قائمة بالطلبات الجديدة (status: pending)
- اسم الدوا المطلوب + بار كود (لو موجود) + اسم الصيدلية اللي طلبت
- زرار "Approve" ينشئ الدوا في الكتالوج بحالة verified
- زرار "Reject" مع سبب

**Pharmacy Management:**
- قائمة صيدليات مع status (pending/active/suspended)
- تفعيل/تعطيل الصيدليات
- عرض الـ reputation score وـ acceptance rate

**Order Overview:**
- قائمة الطلبات مع الـ status
- تفاصيل الأوردر (الدوا، المريض، الصيدلية، التوصيل)
- القدرة على التدخل يدوياً لو في مشكلة

---

## Pharmacy Dashboard (Filament — Panel منفصل)

### الفيتشرز الأساسية:

**المخزون:**
- قائمة بكل أدوية الكتالوج (Master List) مع سيرش وفلتر بالـ category
- كل صنف عنده عداد الكمية — الصيدلي يدوّس + أو - أو يكتب الرقم مباشرة
- زرار "Scan Barcode" (ويب — keyboard input من scanner USB)
- زرار "Request Add Drug" لو الدوا مش في الكتالوج

**الطلبات الواردة:**
- الطلبات اللوحة الرئيسية بيظهر فيها real-time (Reverb WebSocket)
- كل طلب: اسم الدوا، الكمية، عنوان المريض، المسافة، وقت انتهاء النافذة (countdown)
- زرار "قبول" و"رفض" مع سبب الرفض

**Analytics (لاحقاً):**
- أكتر أدوية مطلوبة في منطقتك ومش عندك

---

## Pharmacy Mobile App (Flutter — خفيف)

الهدف الوحيد: الصيدلي يقدر يقبل/يرفض الطلب من موبايله حتى لو مش قاعد قدام الكمبيوتر.

الشاشات:
- Login
- قائمة الطلبات الواردة
- تفاصيل الطلب + قبول/رفض
- تعديل سريع لكمية صنف معين

---

## Patient Mobile App (Flutter)

### UX Principles:
- أسرع طريقة ممكنة من "اسم الدوا" لـ "الطلب اتعمل"
- Real-time tracking بعد الطلب
- تصميم طبي موثوق — مش مبهرج

### الشاشات الأساسية:

```
Onboarding (مرة واحدة):
  → رقم موبايل → OTP (email) → اسم + عنوان

Home:
  → Search bar كبير في المنتصف "ابحث عن دواءك"
  → أحدث طلباتك
  → فئات سريعة (مزمن / طارئ / مكمل غذائي)

Search Results:
  → اسم الدوا + availability indicator
  → "متوفر في صيدليات قريبة" / "دوا نادر — هنبحثله"

Order Flow:
  → تأكيد الدوا والكمية
  → اختيار العنوان
  → الروشتة (لو مطلوب)
  → اختيار طريقة الدفع
  → تأكيد الأوردر

Tracking Screen:
  → Live status (Searching → Accepted → On the Way → Delivered)
  → اسم الصيدلية + رقمها
  → تتبع الكابتن (لو في توصيل خارجي)

Profile:
  → العناوين
  → سجل الطلبات
```

---

## UI/UX Resources للإلهام

### Patient App (Flutter):
- **Dribbble:** ابحث عن "pharmacy delivery app UI" و"medicine app flutter"
  - مجموعة "Pharmacy App Concept" بتاعة purrweb (104K views) — أقرب حاجة لفكرتنا
  - "WSA Pharma - Medicine Delivery App UX" من Appbuff
- **Behance:** ابحث عن "online pharmacy app UX case study"
  - "Redcare | Online Pharmacy Mobile App Design" (5.7K views)
  - "Smart Pharmacy CRM Dashboard" (3K views للداشبورد)
- **مرجع تصميمي حقيقي قريب:** تطبيق Chefaa وYodawy — حملهم وافهم flowهم الأول
- **للتتبع:** استلهم من Uber Eats tracking screen — أحسن تجربة تتبع في السوق

### Pharmacy Dashboard (Filament Web):
- Filament عنده UI جاهز ومرتب — الشغل يبقى في الـ UX Flow مش إعادة اختراع المكونات
- للإلهام على تصميم الـ inventory checklist: ابحث Behance عن "pharmacy POS UI" و"inventory management dashboard"
- المرجع: Shopify Admin UI للبساطة والسرعة في التنفيذ

### Design System للـ Patient App:
- Colors: أزرق طبي (#1A6FA8) + أبيض نظيف — الثقة أهم من الجاذبية
- Typography: خط واضح للعربي (Noto Kufi Arabic أو IBM Plex Arabic)
- الـ Search bar يبقى الـ hero element في الـ home screen — مش banner إعلاني

---

## ترتيب البناء (المراحل)

### المرحلة 0 — الأساس (الأن)
- [ ] Laravel project setup + modules structure
- [ ] MySQL schema كامل (الجداول دي فوق)
- [ ] Filament Admin Panel (Drug Catalog management)
- [ ] Import script للـ drug dataset (24,868 دوا بحالة unverified)
- [ ] Admin verification flow (verify / reject / edit)
- [ ] Drug addition requests من الصيدليات

### المرحلة 1 — الصيدلية
- [ ] Filament Pharmacy Panel (inventory checklist + طلبات واردة)
- [ ] Laravel Reverb (real-time للطلبات الواردة على الويب)
- [ ] FCM setup للإشعارات
- [ ] Pharmacy Flutter app (login + قبول/رفض)
- [ ] Meilisearch setup للسيرش في الكتالوج

### المرحلة 2 — المريض والطلب
- [ ] Patient Flutter app
- [ ] Order creation API
- [ ] Tiered Dispatch engine (Queue jobs + Redis)
- [ ] Atomic claim logic
- [ ] Paymob integration

### المرحلة 3 — التوصيل
- [ ] Delivery abstraction layer
- [ ] Bosta integration (Raw HTTP via Guzzle)
- [ ] Mylerz integration (بعد التواصل مع الـ sales)
- [ ] Delivery webhooks
- [ ] Live tracking في الـ patient app

### المرحلة 4 — الاستقرار والنمو
- [ ] Reputation scoring system
- [ ] Demand Analytics للصيدليات
- [ ] B2B تبادل النواقص بين الصيدليات
- [ ] Admin reporting

---

## القرارات المفتوحة (Pending)

| القرار | الحالة | المطلوب |
|---|---|---|
| Bosta vs Mylerz | ⏳ جاري التحقق | تجربة Bosta raw API على staging + رد Mylerz sales |
| Dynamic pickup في Bosta | ⏳ غير مؤكد | تجربة `pickupAddress` parameter في raw API |
| OTP method | ✅ قرار: Email only | تأكيد رقم الموبايل في أول أوردر يدوياً أو عبر واتساب |
| Same-day delivery | ⏳ | Mylerz الأرجح + Uber Direct كبديل |

---

## ملاحظات تنظيمية (مهمة من اليوم الأول)

- البيع قانوناً يتم من الصيدلية للمريض — المنصة وسيط تقني (عمولة)
- أدوية الجدول `is_scheduled = true` → ممنوع توصيلها نهائياً → تتفلتر من النتائج
- أدوية الروشتة `requires_prescription = true` → خطوة upload إجبارية في الـ order flow
- استشارة قانونية قبل الإطلاق العام

---

## للفريق — مهمة التحقق من الكتالوج

**الهدف:** التحقق من الأدوية في قاعدة البيانات المستوردة والتأكد من صحتها عبر موقع هيئة الدواء المصرية.

**موقع هيئة الدواء للتحقق:**
https://www.ema.gov.eg — قسم "البحث عن مستحضر"

**الـ fields اللي محتاجين تتأكدوا منها لكل دوا:**
1. الاسم التجاري صح (عربي + إنجليزي)
2. التركيب العلمي (scientific name) صح
3. الشركة المصنعة صح
4. السعر الرسمي الحالي (السعر في الداتاسيت ممكن قديم)
5. هل محتاج روشتة؟
6. هل من أدوية الجدول؟

**طريقة الشغل في Admin Panel:**
- افتحوا قائمة الأدوية، فلتروا على `status = unverified`
- كل دوا: انسخوا اسمه → ابحثوا عنه في موقع الهيئة
- لو البيانات صح → دوسوا "Verify"
- لو في بيانات غلط → عدّلوها الأول → بعدين "Verify"
- لو الدوا مش موجود في سجل الهيئة خالص → "Reject"
- ابدأوا بأكثر الأدوية شيوعاً (أدوية السكر، الضغط، الغدة، المضادات الحيوية الشائعة)

**الهدف الأول:** توثيق أول 2000 صنف من الأكثر تداولاً — دي بتغطي الأغلبية الساحقة من الطلبات الفعلية.