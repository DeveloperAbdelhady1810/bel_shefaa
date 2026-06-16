import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../application/order_tracking_controller.dart';
import '../domain/order.dart';

class OrdersHistoryScreen extends ConsumerWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersListControllerProvider);

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('طلباتي'),
        backgroundColor: kMedicalBlue,
        foregroundColor: Colors.white,
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 56, color: kError),
              const SizedBox(height: 12),
              const Text('تعذّر تحميل الطلبات',
                  style: TextStyle(color: kTextSecondary)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () =>
                    ref.read(ordersListControllerProvider.notifier).refresh(),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_bag_outlined,
                      size: 80, color: kTextSecondary),
                  const SizedBox(height: 16),
                  const Text('لا توجد طلبات',
                      style: TextStyle(
                          color: kTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  const Text('ابحث عن دوائك وضع أول طلب',
                      style: TextStyle(color: kTextSecondary)),
                  const SizedBox(height: 24),
                  _GradientButton(
                    label: 'ابحث عن دواء',
                    icon: Icons.search,
                    onPressed: () {
                      if (context.canPop()) context.pop();
                    },
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(ordersListControllerProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) =>
                  _OrderHistoryCard(order: orders[i]),
            ),
          );
        },
      ),
    );
  }
}

// ─── Order History Card ───────────────────────────────────────────────────────

class _OrderHistoryCard extends StatelessWidget {
  const _OrderHistoryCard({required this.order});
  final Order order;

  Color get _statusColor {
    if (order.status == 'delivered') return kSuccess;
    if (order.status == 'cancelled' || order.status == 'failed') return kError;
    return kMedicalBlue;
  }

  @override
  Widget build(BuildContext context) {
    final drugName = order.drug?.nameAr ?? 'دواء #${order.drugId}';
    return _TapScale(
      onTap: () => context.push('/tracking/${order.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
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
        child: Row(
          children: [
            // Left accent bar
            Container(
              width: 4,
              height: 72,
              decoration: BoxDecoration(
                color: _statusColor,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
            ),
            const SizedBox(width: 14),
            // Icon circle
            CircleAvatar(
              radius: 22,
              backgroundColor: _statusColor.withValues(alpha: 0.12),
              child: Icon(Icons.medication, color: _statusColor, size: 22),
            ),
            const SizedBox(width: 12),
            // Drug + order number
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(drugName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: kTextPrimary)),
                  const SizedBox(height: 3),
                  Text('طلب #${order.id}',
                      style: const TextStyle(
                          color: kTextSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  const Text(
                    'اضغط للتتبع',
                    style: TextStyle(
                        fontSize: 10,
                        color: kTextSecondary),
                  ),
                ],
              ),
            ),
            // Status badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status.label,
                    style: TextStyle(
                        fontSize: 11,
                        color: _statusColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

// ─── Gradient Button ──────────────────────────────────────────────────────────

class _GradientButton extends StatefulWidget {
  const _GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.color1 = kMedicalBlue,
    this.color2 = kMedicalBlueDark,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool loading;
  final Color color1;
  final Color color2;

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 90));
  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 0.96).animate(
          CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: _scale,
        child: GestureDetector(
          onTapDown: (_) {
            if (!widget.loading) _ctrl.forward();
          },
          onTapUp: (_) {
            _ctrl.reverse();
            if (!widget.loading) widget.onPressed();
          },
          onTapCancel: () => _ctrl.reverse(),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color1, widget.color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.color1.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: widget.loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.label,
                          style: const TextStyle(
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
      );
}

// ─── Tap Scale Helper ─────────────────────────────────────────────────────────

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
  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 0.96).animate(
          CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: _scale,
        child: GestureDetector(
          onTapDown: (_) => _ctrl.forward(),
          onTapUp: (_) {
            _ctrl.reverse();
            widget.onTap();
          },
          onTapCancel: () => _ctrl.reverse(),
          child: widget.child,
        ),
      );
}
