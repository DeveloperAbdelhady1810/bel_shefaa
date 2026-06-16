# بالشفاء — Manual Work Guide
# كل العمل اليدوي المطلوب منك

This document covers every step that cannot be automated by code — credentials, third-party
accounts, server configuration, and deployment. Work through each section in order.

---

## 1. Environment Variables (`.env`)

Add these to your `.env` file in `D:\bel_shefaa\backend\`. All keys prefixed with `#TODO`
need a real value from you.

```env
# ─── App ──────────────────────────────────────────────────────────────────────
APP_NAME="بالشفاء"
APP_ENV=production          # change to 'production' on server
APP_KEY=                    # run: php artisan key:generate
APP_DEBUG=false             # false on production
APP_URL=https://your-domain.com   # #TODO: your actual domain

# ─── Database ────────────────────────────────────────────────────────────────
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bel_shefaa      # #TODO: your DB name on Hostinger
DB_USERNAME=                # #TODO: your DB user
DB_PASSWORD=                # #TODO: your DB password

# ─── Queue & Cache ───────────────────────────────────────────────────────────
CACHE_STORE=redis
QUEUE_CONNECTION=redis      # IMPORTANT: must be 'redis', not 'sync', for delivery to work
SESSION_DRIVER=redis

REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_PASSWORD=             # #TODO: set if your Redis requires auth

# ─── Delivery ────────────────────────────────────────────────────────────────
# Keep DELIVERY_ACTIVE=false until Bosta/Mylerz credentials are ready.
# When your delivery partner is set up, flip to true — the system will then
# automatically create shipments after pharmacy acceptance.
DELIVERY_ACTIVE=false
DELIVERY_PROVIDER=bosta
BOSTA_API_KEY=              # #TODO: from Bosta dashboard → Settings → API Keys
BOSTA_BASE_URL=https://app.bosta.co/api/v2   # use https://stg.app.bosta.co/api/v2 for staging
BOSTA_WEBHOOK_SECRET=       # #TODO: from Bosta dashboard → Webhooks → Secret

# ─── Delivery — Mylerz (fill when sales team responds) ───────────────────────
MYLERZ_API_KEY=
MYLERZ_BASE_URL=https://api.mylerz.com

# ─── Paymob ──────────────────────────────────────────────────────────────────
PAYMOB_API_KEY=             # #TODO: from Paymob dashboard
PAYMOB_INTEGRATION_ID=      # #TODO: card integration ID
PAYMOB_HMAC_SECRET=         # #TODO: HMAC secret for webhook verification

# ─── Firebase FCM (push notifications) ───────────────────────────────────────
FIREBASE_CREDENTIALS=storage/app/firebase-credentials.json   # #TODO: path to JSON key file

# ─── Meilisearch (drug search) ───────────────────────────────────────────────
SCOUT_DRIVER=meilisearch
MEILISEARCH_HOST=http://127.0.0.1:7700
MEILISEARCH_KEY=            # #TODO: Meilisearch master key

# ─── Mail (OTP delivery) ─────────────────────────────────────────────────────
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailgun.org  # or smtp.gmail.com, sendgrid, etc.
MAIL_PORT=587
MAIL_USERNAME=              # #TODO
MAIL_PASSWORD=              # #TODO
MAIL_FROM_ADDRESS=noreply@your-domain.com
MAIL_FROM_NAME="بالشفاء"

# ─── Laravel Reverb (real-time for pharmacy dashboard) ───────────────────────
REVERB_APP_ID=              # run: php artisan reverb:install
REVERB_APP_KEY=
REVERB_APP_SECRET=
REVERB_HOST=your-domain.com
REVERB_PORT=8080
REVERB_SCHEME=https
```

---

## 2. Bosta Setup

1. **Create an account** at https://app.bosta.co
2. Go to **Settings → API** → create an API key → paste as `BOSTA_API_KEY`
3. Go to **Settings → Webhooks** → add webhook URL:
   ```
   https://your-domain.com/api/webhooks/bosta
   ```
4. Copy the webhook secret → paste as `BOSTA_WEBHOOK_SECRET`
5. In the webhook settings, enable these events:
   - `PACKAGE_RECEIVED` (code 45)
   - `OUT_FOR_DELIVERY` (code 47)
   - `DELIVERED` (code 10)
   - `DELIVERY_FAILED` (code 20)
   - `CANCELLED` (code 46)
   - `RETURNED` (code 48)
6. **Test on staging first**: set `BOSTA_BASE_URL=https://stg.app.bosta.co/api/v2`
   and place a test order. Verify the shipment appears in Bosta's staging dashboard.
7. Once satisfied, switch to production URL.

**Important note on per-order pickup addresses:**
The integration uses `pickupAddress` per request (not a fixed business location). Bosta must
have your account configured to allow dynamic pickup. Contact their support if shipments fail
with a "pickup not allowed" error.

---

## 3. Mylerz Setup

1. You already registered with service type: **Domestic & Express**.
2. Contact the Mylerz sales team to get API credentials.
3. Once received, fill `MYLERZ_API_KEY` and `MYLERZ_BASE_URL`.
4. Change `DELIVERY_PROVIDER=mylerz` to switch the active provider.
5. Implement status mapping in `Modules/Delivery/app/Services/MylerzDeliveryService.php`
   — the stub is already in place.
6. Update the Mylerz webhook handler in
   `Modules/Delivery/app/Http/Controllers/WebhookController@mylerz` with the correct
   field names from Mylerz's API docs.

---

## 4. Firebase FCM (Push Notifications)

The codebase has a `PushServiceStub` (no-op) wired in both apps. When you're ready to enable
real push notifications:

### Backend
1. Go to **Firebase Console → Project Settings → Service Accounts**
2. Click "Generate new private key" → download the JSON file
3. Place it at `storage/app/firebase-credentials.json`
4. Set `FIREBASE_CREDENTIALS=storage/app/firebase-credentials.json`
5. Verify the `NotificationServiceInterface` implementation uses this path
   (search for `NotificationServiceInterface` in `Modules/Dispatch/`)

### Pharmacy Flutter App
1. Go to **Firebase Console → Add App → Android**
2. Package name: `net.quadrocloud.bel_shefaa.pharmacy`
3. Download `google-services.json` → place in `pharmacy_app/android/app/`
4. Follow the FlutterFire setup steps: `flutterfire configure`
5. Replace `PushServiceStub` with `FirebasePushService`:
   - Add `firebase_messaging: ^15.x.x` to `pubspec.yaml`
   - Create `lib/features/notifications/firebase_push_service.dart`
   - Update `pushServiceProvider` in `auth_controller.dart` to use it

### Patient Flutter App
Same steps as above but:
- Package name: `net.quadrocloud.bel_shefaa`
- Place `google-services.json` in `patient_app/android/app/`

---

## 5. Meilisearch Setup

The drug catalog uses Laravel Scout + Meilisearch for fast Arabic search (24,868 drugs).

### On the server
```bash
# Install Meilisearch (Linux/Hostinger VPS)
curl -L https://install.meilisearch.com | sh
./meilisearch --master-key="your-master-key" --env=production &

# Or run as a systemd service (recommended for production)
```

### Index the drugs
```bash
# In the backend directory:
php artisan scout:import "Modules\Catalog\Models\Drug"
```
This imports all ~24,868 verified drugs into the Meilisearch index. Runs once; new drugs
are indexed automatically on create/update.

### Configure Arabic search
In your Meilisearch dashboard (or via API), set the `drugs` index settings:
```json
{
  "searchableAttributes": ["name_ar", "name_en", "scientific_name"],
  "rankingRules": ["words", "typo", "proximity", "attribute", "sort", "exactness"]
}
```

---

## 6. Queue Worker (Critical for Delivery)

The `CreateShipmentListener` is a queued listener (`ShouldQueue`). Without a running queue
worker, shipments will never be created after pharmacy acceptance.

```bash
# Development (in the backend directory):
php artisan queue:work --queue=default --tries=3

# Production (as a long-running process — use supervisor):
```

### Supervisor config (Linux production)
```ini
[program:bel-shefaa-worker]
command=php /path/to/backend/artisan queue:work redis --queue=default --tries=3 --timeout=90
directory=/path/to/backend
autostart=true
autorestart=true
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/path/to/backend/storage/logs/worker.log
```

### Laravel Horizon (recommended)
Horizon gives a real-time dashboard at `/horizon` to monitor queued jobs.
```bash
php artisan horizon:install
php artisan horizon
```
Replace the `queue:work` supervisor entry with `php artisan horizon`.

---

## 7. Cron Job (Scheduler)

The scheduler runs two recurring tasks:
- `dispatch:tick` — every minute (expires broadcasts, expands dispatch radius)
- `reputation:recalculate` — daily at 03:00 (recomputes pharmacy scores)

### On cPanel / Hostinger
Add this cron job (runs every minute):
```
* * * * * cd /path/to/backend && php artisan schedule:run >> /dev/null 2>&1
```

---

## 8. Admin Panel — First Login

1. Create the first admin user:
   ```bash
   php artisan make:filament-user
   ```
   Or via tinker:
   ```bash
   php artisan tinker
   \App\Models\User::create(['name' => 'Admin', 'email' => 'admin@belshefaa.com', 'password' => bcrypt('strong-password')]);
   ```
2. Go to `https://your-domain.com/admin`
3. Log in with the credentials above.

---

## 9. First Pharmacy Setup

After the admin panel is running, create the first pharmacy:

```bash
php artisan tinker
```
```php
// Create a pharmacy
$pharmacy = \Modules\Pharmacy\Models\Pharmacy::create([
    'name'              => 'صيدلية النيل',
    'owner_name'        => 'محمد علي',
    'license_number'    => 'LIC-001',
    'address'           => '12 شارع النيل',
    'city'              => 'القاهرة',
    'district'          => 'المعادي',
    'lat'               => 29.9626,
    'lng'               => 31.2497,
    'phone'             => '01000000000',
    'has_delivery'      => false,
    'delivery_radius_km'=> 0,
    'status'            => 'active',
]);

// Create a pharmacy user (pharmacist login)
\Modules\Pharmacy\Models\PharmacyUser::create([
    'pharmacy_id' => $pharmacy->id,
    'name'        => 'أحمد محمد',
    'email'       => 'pharmacy@belshefaa.com',
    'phone'       => '01111111111',
    'password'    => bcrypt('pharmacy-password'),
    'role'        => 'owner',
]);
```

---

## 10. Paymob Setup

1. Log in to https://accept.paymob.com
2. Go to **Developers → API Keys** → copy your API key → set `PAYMOB_API_KEY`
3. Create a **Card Payment Integration**:
   - Go to **Payment Integrations → Card Payments**
   - Note the Integration ID → set `PAYMOB_INTEGRATION_ID`
4. Set up the **HMAC webhook**:
   - Go to **Settings → Webhooks**
   - Set callback URL: `https://your-domain.com/api/patient/orders/paymob-webhook`
   - Copy HMAC secret → set `PAYMOB_HMAC_SECRET`
5. Test with Paymob's test card: `4987654321098769`, expiry any future date, CVV `123`.

---

## 11. Server Deployment (Hostinger VPS)

```bash
# 1. Upload files (or git clone)
git clone https://github.com/your-repo/bel-shefaa.git /var/www/bel-shefaa
cd /var/www/bel-shefaa/backend

# 2. Install PHP dependencies
composer install --no-dev --optimize-autoloader

# 3. Set permissions
chmod -R 755 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

# 4. Environment
cp .env.example .env
# Fill in all values from Section 1
php artisan key:generate

# 5. Run all migrations
php artisan migrate --force

# 6. Import drug catalog into Meilisearch
php artisan scout:import "Modules\Catalog\Models\Drug"

# 7. Cache config for production
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 8. Start queue worker (via supervisor — see Section 6)
# 9. Set up cron job (see Section 7)
# 10. Start Reverb for real-time pharmacy dashboard
php artisan reverb:start --port=8080
```

### Nginx config
```nginx
server {
    listen 443 ssl;
    server_name your-domain.com;
    root /var/www/bel-shefaa/backend/public;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
    }

    # Reverb WebSocket proxy
    location /app {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
    }
}
```

---

## 12. Flutter App — API Base URL

Before releasing the apps, update the base URL in both apps from the emulator address:

**Patient app:** `D:\bel_shefaa\patient_app\lib\core\config\app_config.dart`
**Pharmacy app:** `D:\bel_shefaa\pharmacy_app\lib\core\config\app_config.dart`

Change:
```dart
const String kApiBaseUrl = 'http://10.0.2.2:8000';
```
To:
```dart
const String kApiBaseUrl = 'https://your-domain.com';
```

---

## 13. Flutter App — Android Release Build

```bash
# Generate a signing keystore (do once, keep safe)
keytool -genkey -v -keystore bel-shefaa.keystore -alias bel-shefaa -keyalg RSA -keysize 2048 -validity 10000

# Patient app
cd D:\bel_shefaa\patient_app
flutter build apk --release
# APK at: build/app/outputs/flutter-apk/app-release.apk

# Pharmacy app
cd D:\bel_shefaa\pharmacy_app
flutter build apk --release
```

For Play Store: use `flutter build appbundle` instead of `flutter build apk`.

---

## 14. Legal & Compliance (Before Public Launch)

- [ ] استشارة قانونية: التأكد من أن المنصة مرخصة كوسيط تقني (مش صيدلية)
- [ ] إضافة شروط الاستخدام وسياسة الخصوصية في التطبيق
- [ ] التأكد من أن أدوية الجدول (`is_scheduled = true`) مفلترة بشكل صحيح (تمت برمجتها)
- [ ] التأكد من أن أدوية الروشتة تتطلب رفع صورة (تمت برمجتها)
- [ ] مراجعة متطلبات هيئة الدواء المصرية للبيع الإلكتروني
- [ ] تسجيل الشركة / السجل التجاري قبل الإطلاق العام

---

## 15. What's Automatically Handled (No Action Needed)

These work without any configuration:

| Feature | Status |
|---|---|
| Drug catalog (24,868 drugs) | ✅ Already imported and verified |
| Admin panel | ✅ Works at `/admin` after creating user (Section 8) |
| Pharmacy panel | ✅ Works at `/pharmacy` after creating pharmacy (Section 9) |
| Dispatch engine (tiered radius expansion) | ✅ Runs via `dispatch:tick` cron |
| Atomic order claim (race condition safe) | ✅ DB-level lock |
| Reputation score daily recalculation | ✅ Runs via `reputation:recalculate` cron |
| COD order flow | ✅ No payment config needed |
| Prescription image upload | ✅ Stored in `storage/app/public` |
| Demand analytics page | ✅ Available in pharmacy panel |
| B2B stock transfer API | ✅ Live at `/api/pharmacy/stock-transfers/` |
| Delivery status tracking (patient polling) | ✅ Patient app polls every 10s |
| Pharmacy delivery webhooks | ✅ Live at `/api/webhooks/bosta` and `/api/webhooks/mylerz` |

---

## Summary Checklist

### Must-do before first order:
- [ ] Configure all `.env` variables (Section 1)
- [ ] Set up Bosta account + webhook URL (Section 2)
- [ ] Run queue worker / supervisor (Section 6)
- [ ] Set up cron job for scheduler (Section 7)
- [ ] Create admin user (Section 8)
- [ ] Create first pharmacy + user (Section 9)

### Must-do before accepting payments:
- [ ] Configure Paymob (Section 10)

### Must-do before public release:
- [ ] Set up Firebase FCM for push notifications (Section 4)
- [ ] Set up Meilisearch and import drug index (Section 5)
- [ ] Deploy to production server (Section 11)
- [ ] Update API base URL in Flutter apps (Section 12)
- [ ] Legal review (Section 14)

### Nice-to-have:
- [ ] Laravel Horizon for queue monitoring (Section 6)
- [ ] Mylerz integration once sales team responds (Section 3)
