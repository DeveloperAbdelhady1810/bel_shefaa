import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final patient  = authAsync.valueOrNull;
    final name = patient is AuthAuthenticated ? patient.patient.name : '';

    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          // ── Gradient SliverAppBar ──────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: kMedicalBlueDark,
            foregroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            actions: [
              IconButton(
                icon: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline,
                      color: Colors.white, size: 20),
                ),
                onPressed: () => context.push('/profile'),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
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
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name.isNotEmpty ? 'أهلاً، $name 👋' : 'أهلاً بك 👋',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ابحث عن دوائك، نوصّله لباب بيتك',
                          style: GoogleFonts.notoKufiArabic(
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
          ),

          // ── Floating search bar overlapping gradient ───────────────
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SearchBar(
                  controller: _searchCtrl,
                  searching: _searching,
                  onTap: _openSearch,
                  onClose: _closeSearch,
                  onChanged: (q) => ref
                      .read(drugSearchControllerProvider.notifier)
                      .onQueryChanged(q),
                ),
              ),
            ),
          ),

          // ── Content ────────────────────────────────────────────────
          if (_searching)
            SliverFillRemaining(
              child: _SearchResultsPanel(onDrugTap: _onDrugTap),
            )
          else
            ..._HomeContent(
              onCategoryTap: (q) {
                _searchCtrl.text = q;
                _openSearch();
                ref
                    .read(drugSearchControllerProvider.notifier)
                    .onQueryChanged(q);
              },
            ).buildSlivers(context, ref),
        ],
      ),
    );
  }
}

// ─── Floating Search Bar ──────────────────────────────────────────────────────

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
      height: 56,
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDivider),
        boxShadow: const [
          BoxShadow(color: kShadowBlue, blurRadius: 20, offset: Offset(0, 6)),
          BoxShadow(color: kShadowDeep, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search_rounded, color: kMedicalBlue, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: searching
                ? TextField(
                    controller: controller,
                    onChanged: onChanged,
                    autofocus: true,
                    style: GoogleFonts.notoKufiArabic(
                        color: kTextPrimary, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن دوائك...',
                      hintStyle: GoogleFonts.notoKufiArabic(
                          color: kTextSecondary, fontSize: 15),
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
                    child: Text(
                      'ابحث عن دوائك...',
                      style: GoogleFonts.notoKufiArabic(
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
    );
  }
}

// ─── Home Content (slivers) ───────────────────────────────────────────────────

class _HomeContent {
  const _HomeContent({required this.onCategoryTap});
  final ValueChanged<String> onCategoryTap;

  // (label, emoji, query)
  static const _categories = [
    ('ضغط الدم',         Icons.favorite_outline,       'ضغط'),
    ('السكري',           Icons.bloodtype_outlined,      'سكري'),
    ('الغدة الدرقية',   Icons.biotech_outlined,        'غدة'),
    ('مضادات حيوية',    Icons.medication_outlined,     'مضاد حيوي'),
    ('مسكنات',           Icons.healing_outlined,        'مسكن'),
    ('مكملات غذائية',   Icons.emoji_food_beverage_outlined, 'فيتامين'),
  ];

  static const _activeChipColors = [
    kAmber, kMedicalBlue, Color(0xFF7C3AED), kError,
    kSuccess, kAmber,
  ];

  List<Widget> buildSlivers(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersListControllerProvider);

    return [
      // Categories header
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Text(
            'فئات سريعة',
            style: GoogleFonts.cairo(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: kTextPrimary),
          ),
        ),
      ),

      // Categories horizontal scroll
      SliverToBoxAdapter(
        child: SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final (label, icon, query) = _categories[i];
              final color = _activeChipColors[i % _activeChipColors.length];
              return _CategoryChip(
                label: label,
                icon: icon,
                accentColor: color,
                onTap: () => onCategoryTap(query),
              );
            },
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
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: kTextPrimary),
              ),
              GestureDetector(
                onTap: () => context.push('/orders-history'),
                child: Text(
                  'عرض الكل',
                  style: GoogleFonts.cairo(
                      color: kMedicalBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),

      // Recent orders
      ordersAsync.when(
        loading: () => const SliverToBoxAdapter(
          child: Center(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator())),
        ),
        error: (_, __) => const SliverToBoxAdapter(
          child: Center(child: Text('تعذّر تحميل الطلبات')),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'لا توجد طلبات سابقة',
                    style: GoogleFonts.notoKufiArabic(
                        color: kTextSecondary),
                  ),
                ),
              ),
            );
          }
          final recent = orders.take(3).toList();
          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
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
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      onTap: onTap,
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kDivider),
          boxShadow: const [
            BoxShadow(color: kShadowBlue, blurRadius: 16, offset: Offset(0, 4)),
            BoxShadow(color: kShadowDeep, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.cairo(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: kTextPrimary),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
        decoration: kCardDecoration(),
        child: Row(
          children: [
            // Left accent bar
            Container(
              width: 4, height: 64,
              decoration: BoxDecoration(
                color: _statusColor,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(20)),
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
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: kTextPrimary)),
                  const SizedBox(height: 3),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status.label,
                      style: GoogleFonts.cairo(
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
      return Center(
        child: Text('اكتب اسم الدواء للبحث',
            style: GoogleFonts.notoKufiArabic(color: kTextSecondary)),
      );
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
          child: Text(state.error!,
              style: GoogleFonts.notoKufiArabic(color: kError)));
    }

    if (state.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 56, color: kTextSecondary),
            const SizedBox(height: 12),
            Text('لم يتم العثور على نتائج',
                style: GoogleFonts.notoKufiArabic(
                    color: kTextSecondary, fontSize: 15)),
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
        decoration: kCardDecoration(),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: drug.available
                  ? kSuccessLight
                  : kAmberLight,
              child: Icon(Icons.medication,
                  color: drug.available ? kSuccess : kAmber, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(drug.nameAr,
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: kTextPrimary)),
                  if (sub.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(sub,
                        style: GoogleFonts.notoKufiArabic(
                            color: kTextSecondary, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: drug.available ? kSuccessLight : kAmberLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                drug.available ? 'متوفر' : 'نادر',
                style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: drug.available ? kSuccess : kAmber,
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
