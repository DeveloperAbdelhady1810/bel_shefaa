import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_controller.dart';
import '../application/orders_controller.dart';
import '../domain/incoming_order.dart';

class IncomingOrdersScreen extends ConsumerWidget {
  const IncomingOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final pharmacyName =
        authState.valueOrNull is AuthAuthenticated
            ? (authState.value as AuthAuthenticated).user.pharmacy?.name ??
                'الصيدلية'
            : 'الصيدلية';

    final ordersAsync = ref.watch(ordersControllerProvider);

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: Text(
          pharmacyName,
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kMedicalBlueDark, kMedicalBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          // Order count badge
          ordersAsync.whenOrNull(
            data: (orders) => orders.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 14),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: kAmber,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${orders.length}',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : null,
          ) ?? const SizedBox.shrink(),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined, color: Colors.white),
            tooltip: 'تعديل المخزون',
            onPressed: () => context.push('/stock'),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'تسجيل الخروج',
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: kMedicalBlue,
        onRefresh: () => ref.read(ordersControllerProvider.notifier).refresh(),
        child: ordersAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: kMedicalBlue),
          ),
          error: (e, _) => _ErrorState(
            message: e.toString(),
            onRetry: () =>
                ref.read(ordersControllerProvider.notifier).refresh(),
          ),
          data: (orders) {
            if (orders.isEmpty) return const _EmptyState();
            return _StaggeredOrderList(orders: orders);
          },
        ),
      ),
    );
  }
}

// ── Staggered order list ───────────────────────────────────────────────────────
class _StaggeredOrderList extends StatefulWidget {
  const _StaggeredOrderList({required this.orders});
  final List<IncomingOrder> orders;

  @override
  State<_StaggeredOrderList> createState() => _StaggeredOrderListState();
}

class _StaggeredOrderListState extends State<_StaggeredOrderList> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      itemCount: widget.orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, i) {
        final delay = Duration(milliseconds: i * 80);
        return AnimatedSlide(
          offset: _visible ? Offset.zero : const Offset(0, 0.12),
          duration: Duration(milliseconds: 350 + i * 40),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300 + i * 40),
            curve: Curves.easeOut,
            child: FutureBuilder(
              future: Future.delayed(delay),
              builder: (context, snapshot) {
                return _OrderCard(order: widget.orders[i]);
              },
            ),
          ),
        );
      },
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: kMedicalBlueLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.inbox_outlined,
                size: 56, color: kMedicalBlue),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد طلبات واردة',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: kTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اسحب للأسفل للتحديث',
            style: GoogleFonts.notoKufiArabic(
              color: kTextSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error state ────────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kErrorLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kError.withValues(alpha: 0.30)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.wifi_off_rounded, size: 48, color: kError),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoKufiArabic(
                        color: kTextSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _GradientButton(
              label: 'إعادة المحاولة',
              icon: Icons.refresh_rounded,
              onTap: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Order card ─────────────────────────────────────────────────────────────────
class _OrderCard extends StatefulWidget {
  const _OrderCard({required this.order});
  final IncomingOrder order;

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  late Timer _ticker;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _calcRemaining();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _remaining = _calcRemaining());
    });
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  Duration _calcRemaining() {
    if (widget.order.expiresAt == null) return Duration.zero;
    final expiry =
        DateTime.tryParse(widget.order.expiresAt!) ?? DateTime.now();
    final diff = expiry.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  String get _countdownText {
    if (_remaining == Duration.zero) return 'انتهت المهلة';
    final m =
        _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s =
        _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Countdown badge: amber bg when < 60s, red bg when <= 30s, green otherwise
  Color get _countdownBg {
    if (_remaining.inSeconds <= 30) return kErrorLight;
    if (_remaining.inSeconds <= 60) return kAmberLight;
    return kSuccessLight;
  }

  Color get _countdownColor {
    if (_remaining.inSeconds <= 30) return kError;
    if (_remaining.inSeconds <= 60) return kAmber;
    return kSuccess;
  }

  /// Left accent bar color mirrors countdown
  Color get _accentColor => _countdownColor;

  @override
  Widget build(BuildContext context) {
    final order = widget.order.order;
    final drug = order?.drug;
    final address = order?.patientAddress;

    return _TapScale(
      onTap: () => context.push('/orders/detail', extra: widget.order),
      child: Container(
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
                // Left accent bar (4px rounded)
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _accentColor,
                        _accentColor.withValues(alpha: 0.5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Card content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drug name + countdown chip
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                drug?.nameAr ?? '—',
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: kTextPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Countdown badge — amber when < 60s
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _countdownBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _countdownText,
                                style: GoogleFonts.cairo(
                                  color: _countdownColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Form/strength
                        if (drug?.form != null || drug?.strength != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            [drug?.form, drug?.strength]
                                .whereType<String>()
                                .join(' — '),
                            style: GoogleFonts.notoKufiArabic(
                                color: kTextSecondary, fontSize: 13),
                          ),
                        ],

                        const SizedBox(height: 10),

                        // Quantity row
                        Row(
                          children: [
                            const Icon(Icons.numbers_outlined,
                                size: 15, color: kTextSecondary),
                            const SizedBox(width: 4),
                            Text(
                              'الكمية: ${order?.quantity ?? '—'}',
                              style: GoogleFonts.notoKufiArabic(
                                  fontSize: 13, color: kTextSecondary),
                            ),
                            const SizedBox(width: 16),

                            // Prescription badge
                            if (order?.requiresPrescription == true) ...[
                              const Icon(Icons.receipt_long_rounded,
                                  size: 15, color: kAmber),
                              const SizedBox(width: 4),
                              Text(
                                'يتطلب روشتة',
                                style: GoogleFonts.notoKufiArabic(
                                    color: kAmber,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ],
                        ),

                        // Address + distance chip
                        if (address != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 15, color: kMedicalBlue),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  [address.district, address.city]
                                      .whereType<String>()
                                      .join('، '),
                                  style: GoogleFonts.notoKufiArabic(
                                      fontSize: 13, color: kTextSecondary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 12),

                        // Bottom hint
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'اضغط لعرض التفاصيل',
                              style: GoogleFonts.notoKufiArabic(
                                  color: kTextSecondary.withValues(alpha: 0.7),
                                  fontSize: 11),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios,
                                size: 11,
                                color: kTextSecondary.withValues(alpha: 0.7)),
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
    );
  }
}

// ── Gradient button (shared in this file) ──────────────────────────────────────
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onTap,
    this.icon,
  });
  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kMedicalBlue, kMedicalBlueDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kMedicalBlue.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
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
