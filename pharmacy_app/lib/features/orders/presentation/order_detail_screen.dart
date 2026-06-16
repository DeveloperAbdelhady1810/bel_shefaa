import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final reason = await showDialog<String?>(
      context: context,
      builder: (ctx) => _RejectDialog(),
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
      appBar: AppBar(
        title: const Text('تفاصيل الطلب'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kMedicalBlue, kMedicalBlueDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),

      // ── Floating bottom action bar ──────────────────────────────────────────
      bottomNavigationBar: _isLoading
          ? const SafeArea(
              child: SizedBox(
                height: 96,
                child: Center(
                    child: CircularProgressIndicator(color: kMedicalBlue)),
              ),
            )
          : Container(
              padding:
                  const EdgeInsets.fromLTRB(20, 16, 20, 0),
              decoration: const BoxDecoration(
                color: kSurface,
                boxShadow: [
                  BoxShadow(
                    color: kCardShadowBlue,
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Accept button (green gradient)
                    Expanded(
                      child: _TapScale(
                        onTap: _accept,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [kSuccess, Color(0xFF00956A)],
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
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 6),
                                  Text(
                                    'قبول',
                                    style: TextStyle(
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

                    // Reject button (outlined red)
                    Expanded(
                      child: _TapScale(
                        onTap: _reject,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: kError.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: kError.withValues(alpha: 0.60),
                                width: 1.5),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: _reject,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cancel_outlined,
                                      color: kError, size: 20),
                                  SizedBox(width: 6),
                                  Text(
                                    'رفض',
                                    style: TextStyle(
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
            // ── Drug header card ──────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: kCardShadowBlue,
                      blurRadius: 24,
                      offset: Offset(0, 6)),
                  BoxShadow(
                      color: Color(0x06000000),
                      blurRadius: 6,
                      offset: Offset(0, 1)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Gradient left border
                      Container(
                        width: 5,
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
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: kMedicalBlueLight,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.medication,
                                    color: kMedicalBlue, size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      drug?.nameAr ?? '—',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: kTextPrimary,
                                      ),
                                    ),
                                    if (drug?.nameEn != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        drug!.nameEn,
                                        style: const TextStyle(
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
                                        style: const TextStyle(
                                            color: kTextSecondary,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ],
                                ),
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

            // ── Info sections ─────────────────────────────────────────────────
            _section(
              icon: Icons.medication_outlined,
              title: 'تفاصيل الدواء',
              children: [
                _row('الكمية', '${order?.quantity ?? '—'}'),
                if (order?.requiresPrescription == true)
                  _badge('يتطلب روشتة طبية', kWarning),
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
              icon: Icons.person_outline,
              title: 'المريض',
              children: [
                _row('الاسم', patient?.name ?? '—'),
                if (patient?.phone != null)
                  _row('الهاتف', patient!.phone!),
              ],
            ),

            const SizedBox(height: 14),

            // Payment section with highlighted amount
            _paymentSection(order),

            if (order?.notes != null) ...[
              const SizedBox(height: 14),
              _section(
                icon: Icons.notes_outlined,
                title: 'ملاحظات',
                children: [
                  Text(
                    order!.notes!,
                    style: const TextStyle(
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
      decoration: const BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: kCardShadowBlue,
              blurRadius: 24,
              offset: Offset(0, 6)),
          BoxShadow(
              color: Color(0x06000000),
              blurRadius: 6,
              offset: Offset(0, 1)),
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
                child: Icon(icon, size: 16, color: kMedicalBlue),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: kTextPrimary),
              ),
            ]),
            const SizedBox(height: 12),
            Container(height: 1, color: kBg),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _paymentSection(dynamic order) {
    return Container(
      decoration: const BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: kCardShadowBlue,
              blurRadius: 24,
              offset: Offset(0, 6)),
          BoxShadow(
              color: Color(0x06000000),
              blurRadius: 6,
              offset: Offset(0, 1)),
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
              const Text(
                'الدفع',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: kTextPrimary),
              ),
            ]),
            const SizedBox(height: 12),
            Container(height: 1, color: kBg),
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
                  color: kSuccess.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: kSuccess.withValues(alpha: 0.30)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on_outlined,
                        color: kSuccess, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'المبلغ عند الاستلام',
                      style: TextStyle(
                          color: kTextSecondary, fontSize: 13),
                    ),
                    const Spacer(),
                    Text(
                      '${order!.codAmount!.toStringAsFixed(2)} ج.م',
                      style: const TextStyle(
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(
                    color: kTextSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: kTextPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long, size: 14, color: color),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
        ],
      ),
    );
  }
}

// ── Reject dialog ──────────────────────────────────────────────────────────────
class _RejectDialog extends StatelessWidget {
  _RejectDialog();

  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('سبب الرفض',
          style: TextStyle(fontWeight: FontWeight.w700)),
      content: TextField(
        controller: _ctrl,
        decoration: const InputDecoration(
            hintText: 'اختياري — اذكر السبب إن أردت'),
        maxLines: 3,
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(color: kTextSecondary))),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kError,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, _ctrl.text),
            child: const Text('تأكيد الرفض')),
      ],
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
      vsync: this, duration: const Duration(milliseconds: 90));
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
