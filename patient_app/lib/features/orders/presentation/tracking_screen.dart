import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/order_tracking_controller.dart';
import '../domain/order.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key, required this.orderId});
  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderTrackingProvider(orderId));

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('تتبع الطلب'),
        backgroundColor: kMedicalBlue,
        foregroundColor: Colors.white,
      ),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 56, color: kError),
              const SizedBox(height: 12),
              Text(e.toString(),
                  style: const TextStyle(color: kError),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () =>
                    ref.invalidate(orderTrackingProvider(orderId)),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
        data: (order) => _OrderTrackingBody(order: order),
      ),
    );
  }
}

class _OrderTrackingBody extends StatelessWidget {
  const _OrderTrackingBody({required this.order});
  final Order order;

  static const _steps = [
    'جارٍ البحث',
    'تم القبول / التحضير',
    'في الطريق',
    'تم التوصيل',
  ];

  @override
  Widget build(BuildContext context) {
    final stepIndex  = order.status.stepIndex;
    final isCancelled =
        order.status == 'cancelled' || order.status == 'failed';
    final isDelivered = order.status == 'delivered';

    // Hero card color scheme
    final Color heroColor = isCancelled
        ? kError
        : isDelivered
            ? kSuccess
            : kMedicalBlue;
    final IconData heroIcon = isCancelled
        ? Icons.cancel_outlined
        : isDelivered
            ? Icons.check_circle_outline
            : Icons.local_shipping_outlined;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hero status card ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  heroColor,
                  heroColor == kMedicalBlue ? kMedicalBlueDark : heroColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: heroColor.withValues(alpha: 0.30),
                    blurRadius: 24,
                    offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                Icon(heroIcon, color: Colors.white, size: 60),
                const SizedBox(height: 12),
                Text(
                  order.status.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ── Vertical stepper ──────────────────────────────────────
          if (!isCancelled) ...[
            _TrackingStepper(steps: _steps, currentStep: stepIndex),
            const SizedBox(height: 28),
          ],

          // ── Drug info card ─────────────────────────────────────────
          _InfoCard(
            title: 'الدواء',
            icon: Icons.medication,
            children: [
              _InfoRow('الاسم',
                  order.drug?.nameAr ?? 'دواء #${order.drugId}'),
              _InfoRow('الكمية', '${order.quantity}'),
              if (order.codAmount != null)
                _InfoRow('السعر',
                    '${order.codAmount!.toStringAsFixed(2)} ج.م'),
              if (order.deliveryFee != null)
                _InfoRow('رسوم التوصيل',
                    '${order.deliveryFee!.toStringAsFixed(2)} ج.م'),
            ],
          ),

          const SizedBox(height: 14),

          // ── Pharmacy card ──────────────────────────────────────────
          if (order.pharmacy != null) ...[
            _InfoCard(
              title: 'الصيدلية',
              icon: Icons.store_outlined,
              children: [
                _InfoRow('الاسم', order.pharmacy!.name),
                if (order.pharmacy!.phone != null)
                  _InfoRow('الهاتف', order.pharmacy!.phone!),
                if (order.pharmacy!.address != null)
                  _InfoRow('العنوان', order.pharmacy!.address!),
              ],
            ),
            const SizedBox(height: 14),
          ],

          // ── Payment card ───────────────────────────────────────────
          _InfoCard(
            title: 'الدفع',
            icon: Icons.payment_outlined,
            children: [
              _InfoRow(
                  'طريقة الدفع',
                  order.paymentMethod == 'cod'
                      ? 'كاش عند الاستلام'
                      : 'بطاقة بنكية'),
              _InfoRow(
                  'حالة الدفع',
                  order.paymentStatus == 'paid'
                      ? 'مدفوع'
                      : order.paymentStatus == 'refunded'
                          ? 'مسترد'
                          : 'معلق'),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Vertical Tracking Stepper ────────────────────────────────────────────────

class _TrackingStepper extends StatelessWidget {
  const _TrackingStepper(
      {required this.steps, required this.currentStep});
  final List<String> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
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
      child: Column(
        children: List.generate(steps.length, (i) {
          final done   = i < currentStep;
          final active = i == currentStep;
          final last   = i == steps.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column: circle + connector
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: done ? 32 : active ? 32 : 28,
                    height: done ? 32 : active ? 32 : 28,
                    decoration: BoxDecoration(
                      color: done
                          ? kMedicalBlue
                          : active
                              ? kMedicalBlueLight
                              : const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                      border: active
                          ? Border.all(
                              color: kMedicalBlue, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: done
                          ? const Icon(Icons.check,
                              size: 16, color: Colors.white)
                          : active
                              ? Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: kMedicalBlue,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : Text(
                                  '${i + 1}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: kTextSecondary,
                                      fontWeight: FontWeight.w600),
                                ),
                    ),
                  ),
                  if (!last)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 2,
                      height: 32,
                      color: done
                          ? kMedicalBlue
                          : const Color(0xFFE2E8F0),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              // Right: label
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 4, bottom: last ? 0 : 24),
                  child: Text(
                    steps[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: (done || active)
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: done
                          ? kMedicalBlue
                          : active
                              ? kMedicalBlue
                              : kTextSecondary,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─── Info Card ────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard(
      {required this.title,
      required this.icon,
      required this.children});
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: kMedicalBlueLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: kMedicalBlue),
                ),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: kMedicalBlue,
                        fontSize: 15)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          ...children.map((child) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 2),
                color: kBg.withValues(alpha: 0.5),
                child: child,
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 100,
              child: Text(label,
                  style: const TextStyle(
                      color: kTextSecondary, fontSize: 13))),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: kTextPrimary))),
        ],
      ),
    );
  }
}
