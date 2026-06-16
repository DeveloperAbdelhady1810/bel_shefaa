import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_controller.dart';
import '../../orders/application/order_flow_controller.dart';
import '../../orders/application/order_tracking_controller.dart';
import '../../orders/domain/order.dart';
import '../application/drug_search_controller.dart';
import '../domain/drug_result.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchCtrl = TextEditingController();
  bool _searching = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _searching = true);
    ref.read(drugSearchControllerProvider.notifier).clear();
  }

  void _closeSearch() {
    _searchCtrl.clear();
    ref.read(drugSearchControllerProvider.notifier).clear();
    setState(() => _searching = false);
    FocusScope.of(context).unfocus();
  }

  void _onDrugTap(DrugResult drug) {
    ref.read(orderFlowControllerProvider.notifier).init(drug);
    context.push('/order-flow');
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authControllerProvider);
    final patient = authAsync.valueOrNull;
    final name = patient is AuthAuthenticated ? patient.patient.name : '';

    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          // ── Gradient SliverAppBar ──────────────────────────────────
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: kMedicalBlue,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kMedicalBlueDark, kMedicalBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name.isNotEmpty
                              ? 'مرحباً، $name'
                              : 'مرحباً بك',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ابحث عن دوائك الآن',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () => context.push('/profile'),
              ),
            ],
          ),

          // ── Search bar (pinned below app bar) ──────────────────────
          SliverToBoxAdapter(
            child: _SearchBar(
              controller: _searchCtrl,
              searching: _searching,
              onTap: _openSearch,
              onClose: _closeSearch,
              onChanged: (q) =>
                  ref.read(drugSearchControllerProvider.notifier).onQueryChanged(q),
            ),
          ),

          // ── Content: home or search results ───────────────────────
          if (_searching)
            SliverFillRemaining(
              child: _SearchResultsPanel(onDrugTap: _onDrugTap),
            )
          else
            ..._HomeContent(
              onCategoryTap: (q) {
                _searchCtrl.text = q;
                _openSearch();
                ref.read(drugSearchControllerProvider.notifier).onQueryChanged(q);
              },
            ).buildSlivers(context, ref),
        ],
      ),
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.searching,
    required this.onTap,
    required this.onClose,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool searching;
  final VoidCallback onTap;
  final VoidCallback onClose;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kMedicalBlue,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
                color: kCardShadowBlue,
                blurRadius: 16,
                offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search, color: kMedicalBlue, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: searching
                  ? TextField(
                      controller: controller,
                      onChanged: onChanged,
                      autofocus: true,
                      style: const TextStyle(
                          color: kTextPrimary, fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: 'ابحث عن دواءك...',
                        hintStyle:
                            TextStyle(color: kTextSecondary, fontSize: 15),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        fillColor: Colors.transparent,
                        filled: false,
                      ),
                    )
                  : GestureDetector(
                      onTap: onTap,
                      behavior: HitTestBehavior.opaque,
                      child: const Text(
                        'ابحث عن دواءك...',
                        style: TextStyle(
                            color: kTextSecondary, fontSize: 15),
                      ),
                    ),
            ),
            if (searching)
              IconButton(
                icon: const Icon(Icons.close, color: kTextSecondary, size: 20),
                onPressed: onClose,
                padding: EdgeInsets.zero,
              )
            else
              const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Home Content (returns slivers) ──────────────────────────────────────────

class _HomeContent {
  const _HomeContent({required this.onCategoryTap});
  final ValueChanged<String> onCategoryTap;

  static const _categories = [
    ('ضغط الدم', Icons.favorite_outline, 'ضغط'),
    ('السكري', Icons.bloodtype_outlined, 'سكري'),
    ('الغدة الدرقية', Icons.biotech_outlined, 'غدة'),
    ('مضادات حيوية', Icons.medication_outlined, 'مضاد حيوي'),
    ('مسكنات', Icons.healing_outlined, 'مسكن'),
    ('مكملات غذائية', Icons.emoji_food_beverage_outlined, 'فيتامين'),
  ];

  List<Widget> buildSlivers(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersListControllerProvider);

    return [
      // Categories header
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text(
            'فئات سريعة',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700, color: kTextPrimary),
          ),
        ),
      ),

      // Categories grid
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final (label, icon, query) = _categories[i];
              return _CategoryChip(
                label: label,
                icon: icon,
                onTap: () => onCategoryTap(query),
              );
            },
            childCount: _categories.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.05,
          ),
        ),
      ),

      // Recent orders header
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'آخر طلباتك',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                        fontWeight: FontWeight.w700, color: kTextPrimary),
              ),
              TextButton(
                onPressed: () => context.push('/orders-history'),
                child: const Text('عرض الكل',
                    style: TextStyle(color: kMedicalBlue)),
              ),
            ],
          ),
        ),
      ),

      // Recent orders list
      ordersAsync.when(
        loading: () => const SliverToBoxAdapter(
          child: Center(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator()),
          ),
        ),
        error: (_, __) => const SliverToBoxAdapter(
          child: Center(child: Text('تعذّر تحميل الطلبات')),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'لا توجد طلبات سابقة',
                    style: TextStyle(color: kTextSecondary),
                  ),
                ),
              ),
            );
          }
          final recent = orders.take(3).toList();
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RecentOrderCard(order: recent[i]),
                ),
                childCount: recent.length,
              ),
            ),
          );
        },
      ),
    ];
  }
}

// ─── Category Chip ────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip(
      {required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: kCardShadowBlue,
                blurRadius: 16,
                offset: Offset(0, 4)),
            BoxShadow(
                color: Color(0x06000000),
                blurRadius: 4,
                offset: Offset(0, 1)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kMedicalBlue, kMedicalBlueDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: kTextPrimary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Recent Order Card ────────────────────────────────────────────────────────

class _RecentOrderCard extends StatelessWidget {
  const _RecentOrderCard({required this.order});
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
              height: 64,
              decoration: BoxDecoration(
                color: _statusColor,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16)),
              ),
            ),
            const SizedBox(width: 14),
            CircleAvatar(
              radius: 20,
              backgroundColor: _statusColor.withValues(alpha: 0.12),
              child: Icon(Icons.medication, color: _statusColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(drugName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: kTextPrimary)),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
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
            ),
            const Icon(Icons.chevron_right, color: kTextSecondary),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

// ─── Search Results Panel ─────────────────────────────────────────────────────

class _SearchResultsPanel extends ConsumerWidget {
  const _SearchResultsPanel({required this.onDrugTap});
  final ValueChanged<DrugResult> onDrugTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(drugSearchControllerProvider);

    if (state.query.trim().length < 2) {
      return const Center(
        child: Text('اكتب اسم الدواء للبحث',
            style: TextStyle(color: kTextSecondary)),
      );
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
          child: Text(state.error!,
              style: const TextStyle(color: kError)));
    }

    if (state.results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 56, color: kTextSecondary),
            SizedBox(height: 12),
            Text('لم يتم العثور على نتائج',
                style: TextStyle(color: kTextSecondary, fontSize: 15)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final drug = state.results[i];
        return _DrugSearchTile(drug: drug, onTap: () => onDrugTap(drug));
      },
    );
  }
}

// ─── Drug Search Tile ─────────────────────────────────────────────────────────

class _DrugSearchTile extends StatelessWidget {
  const _DrugSearchTile({required this.drug, required this.onTap});
  final DrugResult drug;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sub = [
      if (drug.scientificName != null) drug.scientificName!,
      if (drug.form != null) drug.form!,
      if (drug.strength != null) drug.strength!,
    ].join(' · ');

    return _TapScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
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
            CircleAvatar(
              backgroundColor: drug.available
                  ? kMedicalBlueLight
                  : const Color(0xFFF3F4F6),
              child: Icon(Icons.medication,
                  color: drug.available ? kMedicalBlue : kTextSecondary,
                  size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(drug.nameAr,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: kTextPrimary)),
                  if (sub.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(sub,
                        style: const TextStyle(
                            color: kTextSecondary, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: drug.available
                    ? kGreenLight
                    : kWarning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                drug.available ? 'متوفر' : 'نادر',
                style: TextStyle(
                    fontSize: 11,
                    color: drug.available ? kSuccess : kWarning,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
      Tween(begin: 1.0, end: 0.95).animate(
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
