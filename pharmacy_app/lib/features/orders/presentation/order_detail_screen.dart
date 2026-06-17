import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../application/orders_controller.dart';
import '../domain/incoming_order.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key, required this.order});

  final IncomingOrder order;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  bool _isLoading = false;

  Future<void> _accept() async {
    setState(() => _isLoading = true);
    try {
      final message = await ref
          .read(ordersControllerProvider.notifier)
          .acceptWithMessage(widget.order.orderId);

      if (!mounted) return;
      final won = !message.contains('أخرى');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: won ? kSuccess : kWarning,
      ));

      if (won) context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: kError,
      ));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _reject() async {
    final reason = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RejectBottomSheet(),
    );
    if (reason == null) return; // cancelled

    setState(() => _isLoading = true);
    try {
      await ref
          .read(ordersControllerProvider.notifier)
          .reject(widget.order.orderId,
              reason: reason.isEmpty ? null : reason);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('تم رفض الطلب.'),
            backgroundColor: kTextSecondary),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: kError,
      ));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order.order;
    final drug = order?.drug;
    final address = order?.patientAddress;
    final patient = order?.patient;

    return Scaffold(
      backgroundColor: kBg,

      // ── Flat white AppBar (detail screen style) ──────────────────────────
      appBar: AppBar(
        backgroundColor: kSurface,
        foregroundColor: kDeepNavy,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تفاصيل الطلب',
          style: GoogleFonts.cairo(
            color: kDeepNavy,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kDeepNavy, size: 20),
          onPressed: () => context.pop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: kDivider),
        ),
      ),

      // ── Floating bottom action bar ────────────────────────────────────────
      bottomNavigationBar: _isLoading
          ? Container(
              color: kSurface,
              child: const SafeArea(
                child: SizedBox(
                  height: 88,
                  child: Center(
                      child: CircularProgressIndicator(color: kMedicalBlue)),
                ),
              ),
            )
          : Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              decoration: const BoxDecoration(
                color: kSurface,
                boxShadow: [
                  BoxShadow(
                    color: kShadowBlue,
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                  BoxShadow(
                    color: kShadowDeep,
                    blurRadius: 4,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Accept button — success gradient
                    Expanded(
                      child: _TapScale(
                        onTap: _accept,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [kSuccess, Color(0xFF059669)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: kSuccess.withValues(alpha: 0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: _accept,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle_outline_rounded,
                                      color: Colors.white, size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    'قبول',
                                    style: GoogleFonts.cairo(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Reject button — outlined red, no fill
                    Expanded(
                      child: _TapScale(
                        onTap: _reject,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: kError.withValues(alpha: 0.70),
                                width: 1.5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: _reject,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.cancel_outlined,
                                      color: kError, size: 20),
                                  const SizedBox(width: 6),
                                  Text(
                                    'رفض',
                                    style: GoogleFonts.cairo(
                                      color: kError,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero drug card with blue left-border ──────────────────────
            Container(
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kDivider, width: 1),
                boxShadow: const [
                  BoxShadow(
                      color: kShadowBlue,
                      blurRadius: 20,
                      offset: Offset(0, 6)),
                  BoxShadow(
                      color: kShadowDeep,
                      blurRadius: 4,
                      offset: Offset(0, 2)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Blue left-border 6px
                      Container(
                        width: 6,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [kMedicalBlue, kMedicalBlueDark],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: kMedicalBlueLight,
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                        Icons.medication_rounded,
                                        color: kMedicalBlue,
                                        size: 28),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          drug?.nameAr ?? '—',
                                          style: GoogleFonts.cairo(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                            color: kTextPrimary,
                                          ),
                                        ),
                                        if (drug?.nameEn != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            drug!.nameEn,
                                            style: GoogleFonts.notoKufiArabic(
                                                color: kTextSecondary,
                                                fontSize: 13),
                                          ),
                                        ],
                                        if (drug?.form != null ||
                                            drug?.strength != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            [drug?.form, drug?.strength]
                                                .whereType<String>()
                                                .join(' — '),
                                            style: GoogleFonts.notoKufiArabic(
                                                color: kTextSecondary,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              // Quantity amber pill + prescription warning
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  _AmberPill(
                                      label:
                                          'الكمية: ${order?.quantity ?? '—'}'),
                                  if (order?.requiresPrescription == true)
                                    const _WarningPill(label: 'يتطلب روشتة طبية'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Drug details section ──────────────────────────────────────
            _section(
              icon: Icons.medication_outlined,
              title: 'تفاصيل الدواء',
              children: [
                _row('الكمية المطلوبة', '${order?.quantity ?? '—'}'),
                if (order?.requiresPrescription == true) ...[
                  const SizedBox(height: 8),
                  _badge('يتطلب روشتة طبية', kWarning),
                ],
              ],
            ),

            const SizedBox(height: 14),

            _section(
              icon: Icons.location_on_outlined,
              title: 'العنوان',
              children: [
                _row('العنوان', address?.addressLine ?? '—'),
                if (address?.district != null)
                  _row('المنطقة', address!.district!),
                if (address?.city != null) _row('المدينة', address!.city!),
              ],
            ),

            const SizedBox(height: 14),

            _section(
              icon: Icons.person_outline_rounded,
              title: 'المريض',
              children: [
                _row('الاسم', patient?.name ?? '—'),
                if (patient?.phone != null)
                  _row('الهاتف', patient!.phone!),
              ],
            ),

            const SizedBox(height: 14),

            // Payment section
            _paymentSection(order),

            if (order?.notes != null) ...[
              const SizedBox(height: 14),
              _section(
                icon: Icons.notes_outlined,
                title: 'ملاحظات',
                children: [
                  Text(
                    order!.notes!,
                    style: GoogleFonts.notoKufiArabic(
                        color: kTextSecondary, fontSize: 14),
                  ),
                ],
              ),
            ],

            // Bottom padding for floating bar
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kDivider, width: 1),
        boxShadow: const [
          BoxShadow(
              color: kShadowBlue,
              blurRadius: 20,
              offset: Offset(0, 6)),
          BoxShadow(
              color: kShadowDeep,
              blurRadius: 4,
              offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: kMedicalBlueLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: kMedicalBlue),
              ),
              const SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: kMedicalBlue,
                  letterSpacing: 0.5,
                ),
              ),
            ]),
            const SizedBox(height: 10),
            const Divider(height: 1, color: kDivider),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _paymentSection(dynamic order) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kDivider, width: 1),
        boxShadow: const [
          BoxShadow(
              color: kShadowBlue,
              blurRadius: 20,
              offset: Offset(0, 6)),
          BoxShadow(
              color: kShadowDeep,
              blurRadius: 4,
              offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: kMedicalBlueLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.payments_outlined,
                    size: 16, color: kMedicalBlue),
              ),
              const SizedBox(width: 10),
              Text(
                'الدفع'.toUpperCase(),
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: kMedicalBlue,
                  letterSpacing: 0.5,
                ),
              ),
            ]),
            const SizedBox(height: 10),
            const Divider(height: 1, color: kDivider),
            const SizedBox(height: 12),
            _row(
              'طريقة الدفع',
              order?.paymentMethod == 'cod' ? 'كاش عند الاستلام' : 'بطاقة',
            ),
            if (order?.codAmount != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: kSuccessLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: kSuccess.withValues(alpha: 0.30)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on_outlined,
                        color: kSuccess, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'المبلغ عند الاستلام',
                      style: GoogleFonts.notoKufiArabic(
                          color: kTextSecondary, fontSize: 13),
                    ),
                    const Spacer(),
                    Text(
                      '${order!.codAmount!.toStringAsFixed(2)} ج.م',
                      style: GoogleFonts.cairo(
                        color: kSuccess,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (order?.deliveryFee != null) ...[
              const SizedBox(height: 6),
              _row(
                'رسوم التوصيل',
                '${order!.deliveryFee!.toStringAsFixed(2)} ج.م',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.notoKufiArabic(
                  color: kTextSecondary, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.notoKufiArabic(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: kTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_rounded, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.notoKufiArabic(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Amber pill badge ───────────────────────────────────────────────────────────
class _AmberPill extends StatelessWidget {
  const _AmberPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: kAmberLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kAmber.withValues(alpha: 0.40)),
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          color: kAmber,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

// ── Warning pill badge ────────────────────────────────────────────────────────
class _WarningPill extends StatelessWidget {
  const _WarningPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: kWarningLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kWarning.withValues(alpha: 0.40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt_long_rounded, size: 13, color: kWarning),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.cairo(
              color: kWarning,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reject bottom sheet ────────────────────────────────────────────────────────
class _RejectBottomSheet extends StatelessWidget {
  _RejectBottomSheet();

  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: kDivider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'سبب الرفض',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: kTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'اختياري — اذكر السبب إن أردت',
            style: GoogleFonts.notoKufiArabic(
              color: kTextSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: _ctrl,
            maxLines: 3,
            style: GoogleFonts.notoKufiArabic(
                fontSize: 14, color: kTextPrimary),
            decoration: const InputDecoration(
              hintText: 'مثال: الكمية غير كافية',
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kTextSecondary,
                    side: const BorderSide(color: kDivider),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TapScale(
                  onTap: () => Navigator.pop(context, _ctrl.text),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: kErrorLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: kError.withValues(alpha: 0.50)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => Navigator.pop(context, _ctrl.text),
                        child: Center(
                          child: Text(
                            'تأكيد الرفض',
                            style: GoogleFonts.cairo(
                              color: kError,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Tap-scale micro-interaction ────────────────────────────────────────────────
class _TapScale extends StatefulWidget {
  const _TapScale({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 80));
  late final Animation<double> _scale = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: ScaleTransition(scale: _scale, child: widget.child),
      );
}
