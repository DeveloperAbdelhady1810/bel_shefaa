import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
        title: Text('تتبع الطلب',
            style: GoogleFonts.cairo(
                color: kDeepNavy, fontSize: 17, fontWeight: FontWeight.w700)),
        backgroundColor: kSurface,
        foregroundColor: kDeepNavy,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                  style: GoogleFonts.notoKufiArabic(color: kError),
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

// ─── Tracking Body ────────────────────────────────────────────────────────────

class _OrderTrackingBody extends StatefulWidget {
  const _OrderTrackingBody({required this.order});
  final Order order;

  @override
  State<_OrderTrackingBody> createState() => _OrderTrackingBodyState();
}

class _OrderTrackingBodyState extends State<_OrderTrackingBody>
    with TickerProviderStateMixin {
  static const _steps = [
    'جارٍ البحث',
    'تم القبول / التحضير',
    'في الطريق',
    'تم التوصيل',
  ];

  // Shimmer animation for active hero card
  late final AnimationController _shimmerCtrl;
  // Pulse animation for active step
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat();
    _pulseCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
        lowerBound: 1.0,
        upperBound: 1.15)
      ..repeat(reverse: true);
    _pulseScale =
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final stepIndex   = order.status.stepIndex;
    final isCancelled = order.status == 'cancelled' || order.status == 'failed';
    final isDelivered = order.status == 'delivered';
    final isActive    = !isCancelled && !isDelivered;

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
          if (isCancelled)
            // Flat error card for cancelled
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: kErrorLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kError.withValues(alpha: 0.25)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      color: kError.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cancel, color: kError, size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(order.status.label,
                      style: GoogleFonts.cairo(
                          color: kError,
                          fontWeight: FontWeight.w800,
                          fontSize: 20)),
                ],
              ),
            )
          else
            // Gradient card with optional shimmer
            AnimatedBuilder(
              animation: _shimmerCtrl,
              builder: (context, child) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: [
                              kMedicalBlueDark,
                              kMedicalBlue,
                              kMedicalBlue.withValues(alpha: 0.85),
                              kMedicalBlueDark,
                            ],
                            stops: [
                              0,
                              (_shimmerCtrl.value - 0.3).clamp(0.0, 1.0),
                              (_shimmerCtrl.value + 0.1).clamp(0.0, 1.0),
                              1,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [heroColor, heroColor],
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
                  child: child,
                );
              },
              child: Column(
                children: [
                  Icon(heroIcon, color: Colors.white, size: 60),
                  const SizedBox(height: 12),
                  Text(
                    order.status.label,
                    style: GoogleFonts.cairo(
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
            _TrackingStepper(
              steps: _steps,
              currentStep: stepIndex,
              pulseScale: _pulseScale,
            ),
            const SizedBox(height: 28),
          ],

          // ── Drug info card ─────────────────────────────────────────
          _InfoCard(
            title: 'الدواء',
            icon: Icons.medication,
            children: [
              _InfoRow(
                  'الاسم', order.drug?.nameAr ?? 'دواء #${order.drugId}'),
              _InfoRow('الكمية', '${order.quantity}'),
              if (order.codAmount != null)
                _AmberInfoRow(
                    'السعر', '${order.codAmount!.toStringAsFixed(2)} ج.م'),
              if (order.deliveryFee != null)
                _AmberInfoRow('رسوم التوصيل',
                    '${order.deliveryFee!.toStringAsFixed(2)} ج.م'),
            ],
          ),

          const SizedBox(height: 14),

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
  const _TrackingStepper({
    required this.steps,
    required this.currentStep,
    required this.pulseScale,
  });
  final List<String> steps;
  final int currentStep;
  final Animation<double> pulseScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: kCardDecoration(),
      child: Column(
        children: List.generate(steps.length, (i) {
          final done   = i < currentStep;
          final active = i == currentStep;
          final last   = i == steps.length - 1;

          Widget circle = AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: (done || active) ? 32 : 28,
            height: (done || active) ? 32 : 28,
            decoration: BoxDecoration(
              color: done
                  ? kSuccess
                  : active
                      ? kMedicalBlue
                      : const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
              border: active
                  ? Border.all(color: kMedicalBlue, width: 2)
                  : null,
            ),
            child: Center(
              child: done
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : active
                      ? Container(
                          width: 10, height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        )
                      : Text('${i + 1}',
                          style: GoogleFonts.cairo(
                              fontSize: 11,
                              color: kTextSecondary,
                              fontWeight: FontWeight.w600)),
            ),
          );

          // Pulse active circle
          if (active) {
            circle = ScaleTransition(scale: pulseScale, child: circle);
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  circle,
                  if (!last)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 2, height: 32,
                      color: done ? kMedicalBlue : kDivider,
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 4, bottom: last ? 0 : 24),
                  child: Text(
                    steps[i],
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: (done || active)
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: (done || active) ? kMedicalBlue : kTextSecondary,
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
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: kMedicalBlueLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: kMedicalBlue),
                ),
                const SizedBox(width: 10),
                Text(title,
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w700,
                        color: kMedicalBlue,
                        fontSize: 15)),
              ],
            ),
          ),
          Divider(height: 1, color: kDivider),
          ...children.map((child) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 100,
                child: Text(label,
                    style: GoogleFonts.notoKufiArabic(
                        color: kTextSecondary, fontSize: 13))),
            Expanded(
                child: Text(value,
                    style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w500, color: kTextPrimary))),
          ],
        ),
      );
}

class _AmberInfoRow extends StatelessWidget {
  const _AmberInfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 100,
                child: Text(label,
                    style: GoogleFonts.notoKufiArabic(
                        color: kTextSecondary, fontSize: 13))),
            Text(value,
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w700,
                    color: kAmber,
                    fontSize: 14)),
          ],
        ),
      );
}
