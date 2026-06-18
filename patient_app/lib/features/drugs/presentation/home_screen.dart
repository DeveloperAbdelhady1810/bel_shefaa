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

// ─── Category data ─────────────────────────────────────────────────────────────
class _Cat {
  const _Cat(this.label, this.query, this.imageUrl);
  final String label;
  final String query;
  final String imageUrl;
}

const _kCategories = [
  _Cat(
    'مضادات حيوية',
    'مضاد حيوي',
    'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400&h=400&fit=crop&q=75',
  ),
  _Cat(
    'ضغط الدم',
    'ضغط',
    'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=400&h=400&fit=crop&q=75',
  ),
  _Cat(
    'السكري',
    'سكري',
    'https://images.unsplash.com/photo-1593538312308-d4c29d8dc7f1?w=400&h=400&fit=crop&q=75',
  ),
  _Cat(
    'مسكنات ألم',
    'مسكن',
    'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=400&h=400&fit=crop&q=75',
  ),
  _Cat(
    'فيتامينات',
    'فيتامين',
    'https://images.unsplash.com/photo-1550572017-edd951b55104?w=400&h=400&fit=crop&q=75',
  ),
  _Cat(
    'الغدة الدرقية',
    'غدة',
    'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=400&fit=crop&q=75',
  ),
  _Cat(
    'أدوية الأطفال',
    'اطفال',
    'https://images.unsplash.com/photo-1632833239869-a37e3a5806d2?w=400&h=400&fit=crop&q=75',
  ),
  _Cat(
    'بدون روشتة',
    'دون روشتة',
    'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?w=400&h=400&fit=crop&q=75',
  ),
  _Cat(
    'عناية بالبشرة',
    'بشرة',
    'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400&h=400&fit=crop&q=75',
  ),
];

// ─── Home Screen ───────────────────────────────────────────────────────────────
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

  void _onCategoryTap(String query) {
    _searchCtrl.text = query;
    _openSearch();
    ref.read(drugSearchControllerProvider.notifier).onQueryChanged(query);
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: kBg,
        body: Column(
          children: [
            // ── Blue top zone (address + search) ──────────────────────
            _BlueTopZone(
              name: name,
              searchCtrl: _searchCtrl,
              searching: _searching,
              onProfileTap: () => context.push('/profile'),
              onSearchTap: _openSearch,
              onSearchClose: _closeSearch,
              onSearchChanged: (q) => ref
                  .read(drugSearchControllerProvider.notifier)
                  .onQueryChanged(q),
            ),

            // ── Scrollable body ────────────────────────────────────────
            Expanded(
              child: _searching
                  ? _SearchResultsPanel(onDrugTap: _onDrugTap)
                  : _HomeBody(onCategoryTap: _onCategoryTap),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Blue Top Zone ─────────────────────────────────────────────────────────────
class _BlueTopZone extends StatelessWidget {
  const _BlueTopZone({
    required this.name,
    required this.searchCtrl,
    required this.searching,
    required this.onProfileTap,
    required this.onSearchTap,
    required this.onSearchClose,
    required this.onSearchChanged,
  });

  final String name;
  final TextEditingController searchCtrl;
  final bool searching;
  final VoidCallback onProfileTap;
  final VoidCallback onSearchTap;
  final VoidCallback onSearchClose;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kMedicalBlue,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address row
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التوصيل إلى',
                          style: GoogleFonts.cairo(
                            color: Colors.white.withValues(alpha: 0.70),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name.isNotEmpty
                                    ? 'أهلاً، $name'
                                    : 'أضف عنوانك',
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white70,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search bar
              _SearchBar(
                controller: searchCtrl,
                searching: searching,
                onTap: onSearchTap,
                onClose: onSearchClose,
                onChanged: onSearchChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Search Bar ────────────────────────────────────────────────────────────────
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
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x30000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(
            Icons.search_rounded,
            color: searching ? kMedicalBlue : const Color(0xFF94A3B8),
            size: 22,
          ),
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
                      'ما الذي تبحث عنه؟',
                      style: GoogleFonts.notoKufiArabic(
                          color: const Color(0xFF94A3B8), fontSize: 15),
                    ),
                  ),
          ),
          if (searching)
            GestureDetector(
              onTap: onClose,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.close_rounded,
                    color: Color(0xFF94A3B8), size: 20),
              ),
            )
          else
            const SizedBox(width: 14),
        ],
      ),
    );
  }
}

// ─── Home Body ─────────────────────────────────────────────────────────────────
class _HomeBody extends ConsumerWidget {
  const _HomeBody({required this.onCategoryTap});
  final ValueChanged<String> onCategoryTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersListControllerProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        // Promo banner
        const _PromoBanner(),
        const SizedBox(height: 26),

        // Categories header
        Text(
          'ابحث بالقسم',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: kDeepNavy,
          ),
        ),
        const SizedBox(height: 14),

        // Photo category grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.88,
          ),
          itemCount: _kCategories.length,
          itemBuilder: (context, i) => _PhotoCategoryCard(
            cat: _kCategories[i],
            onTap: () => onCategoryTap(_kCategories[i].query),
          ),
        ),

        const SizedBox(height: 30),

        // Recent orders header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'آخر طلباتك',
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: kDeepNavy,
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/orders-history'),
              child: Text(
                'عرض الكل',
                style: GoogleFonts.cairo(
                  color: kMedicalBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ordersAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) =>
              const Center(child: Text('تعذّر تحميل الطلبات')),
          data: (orders) {
            if (orders.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt_long_outlined,
                          size: 48, color: kMedicalBlue.withValues(alpha: 0.3)),
                      const SizedBox(height: 10),
                      Text(
                        'لا توجد طلبات سابقة',
                        style: GoogleFonts.notoKufiArabic(
                            color: kTextSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            }
            final recent = orders.take(3).toList();
            return Column(
              children: [
                for (final order in recent)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _RecentOrderCard(order: order),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ─── Photo Category Card ───────────────────────────────────────────────────────
class _PhotoCategoryCard extends StatefulWidget {
  const _PhotoCategoryCard({required this.cat, required this.onTap});
  final _Cat cat;
  final VoidCallback onTap;

  @override
  State<_PhotoCategoryCard> createState() => _PhotoCategoryCardState();
}

class _PhotoCategoryCardState extends State<_PhotoCategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 80));
  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 0.94).animate(
          CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Photo background
              Image.network(
                widget.cat.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: kMedicalBlue.withValues(alpha: 0.08),
                    child: const Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: kMedicalBlue),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: kMedicalBlueLight,
                  child: const Center(
                    child: Icon(Icons.medication_rounded,
                        color: kMedicalBlue, size: 32),
                  ),
                ),
              ),

              // Bottom gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 64,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xD9000000), Colors.transparent],
                    ),
                  ),
                ),
              ),

              // Label
              Positioned(
                bottom: 8,
                left: 6,
                right: 6,
                child: Text(
                  widget.cat.label,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    shadows: const [
                      Shadow(blurRadius: 6, color: Color(0x99000000)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Promo Banner ──────────────────────────────────────────────────────────────
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D4F7A), kMedicalBlue],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            left: -16,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'دواءك بباب بيتك',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'شبكة صيدليات متعاقدة — توصيل لأي مكان',
                        style: GoogleFonts.notoKufiArabic(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.local_pharmacy_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Recent Order Card ─────────────────────────────────────────────────────────
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
    return GestureDetector(
      onTap: () => context.push('/tracking/${order.id}'),
      child: Container(
        decoration: kCardDecoration(),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 64,
              decoration: BoxDecoration(
                color: _statusColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
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
                  Text(
                    drugName,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: kTextPrimary,
                    ),
                  ),
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
                        fontWeight: FontWeight.w600,
                      ),
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

// ─── Search Results Panel ──────────────────────────────────────────────────────
class _SearchResultsPanel extends ConsumerWidget {
  const _SearchResultsPanel({required this.onDrugTap});
  final ValueChanged<DrugResult> onDrugTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(drugSearchControllerProvider);

    if (state.query.trim().length < 2) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_rounded,
                size: 52, color: kMedicalBlue.withValues(alpha: 0.25)),
            const SizedBox(height: 12),
            Text(
              'اكتب اسم الدواء للبحث',
              style: GoogleFonts.notoKufiArabic(
                  color: kTextSecondary, fontSize: 15),
            ),
          ],
        ),
      );
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child:
            Text(state.error!, style: GoogleFonts.notoKufiArabic(color: kError)),
      );
    }

    if (state.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 56, color: kTextSecondary),
            const SizedBox(height: 12),
            Text(
              'لم يتم العثور على نتائج',
              style: GoogleFonts.notoKufiArabic(
                  color: kTextSecondary, fontSize: 15),
            ),
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

// ─── Drug Search Tile ──────────────────────────────────────────────────────────
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: kCardDecoration(),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: drug.available ? kSuccessLight : kAmberLight,
              child: Icon(
                Icons.medication,
                color: drug.available ? kSuccess : kAmber,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drug.nameAr,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: kTextPrimary,
                    ),
                  ),
                  if (sub.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      sub,
                      style: GoogleFonts.notoKufiArabic(
                          color: kTextSecondary, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
