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
      appBar: AppBar(
        title: Text('مرحباً${name.isNotEmpty ? "، $name" : ""} 👋'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(
            controller: _searchCtrl,
            searching: _searching,
            onTap: _openSearch,
            onClose: _closeSearch,
            onChanged: (q) =>
                ref.read(drugSearchControllerProvider.notifier).onQueryChanged(q),
          ),
          if (_searching)
            Expanded(child: _SearchResultsPanel(onDrugTap: _onDrugTap))
          else
            Expanded(child: _HomeContent(onCategoryTap: (q) {
              _searchCtrl.text = q;
              _openSearch();
              ref.read(drugSearchControllerProvider.notifier).onQueryChanged(q);
            })),
        ],
      ),
    );
  }
}

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
      child: TextField(
        controller: controller,
        onTap: onTap,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'ابحث عن دواءك...',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon: searching
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onClose,
                )
              : null,
          filled: true,
          fillColor: Colors.white.withValues(alpha:0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersListControllerProvider);

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(ordersListControllerProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text('فئات سريعة',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ),
          ),
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
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.1,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('آخر طلباتك',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  TextButton(
                    onPressed: () => context.push('/orders-history'),
                    child: const Text('عرض الكل'),
                  ),
                ],
              ),
            ),
          ),
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
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('لا توجد طلبات سابقة',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                );
              }
              final recent = orders.take(3).toList();
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _RecentOrderCard(order: recent[i]),
                    childCount: recent.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip(
      {required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: kMedicalBlueLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kMedicalBlue, size: 28),
            const SizedBox(height: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: kMedicalBlue),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _RecentOrderCard extends StatelessWidget {
  const _RecentOrderCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final drugName = order.drug?.nameAr ?? 'دواء #${order.drugId}';
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading:
            const CircleAvatar(child: Icon(Icons.medication, color: kMedicalBlue)),
        title: Text(drugName),
        subtitle: Text(order.status.label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/tracking/${order.id}'),
      ),
    );
  }
}

class _SearchResultsPanel extends ConsumerWidget {
  const _SearchResultsPanel({required this.onDrugTap});
  final ValueChanged<DrugResult> onDrugTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(drugSearchControllerProvider);

    if (state.query.trim().length < 2) {
      return const Center(
        child: Text('اكتب اسم الدواء للبحث',
            style: TextStyle(color: Colors.grey)),
      );
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text(state.error!, style: const TextStyle(color: Colors.red)));
    }

    if (state.results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('لم يتم العثور على نتائج',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final drug = state.results[i];
        return _DrugSearchTile(drug: drug, onTap: () => onDrugTap(drug));
      },
    );
  }
}

class _DrugSearchTile extends StatelessWidget {
  const _DrugSearchTile({required this.drug, required this.onTap});
  final DrugResult drug;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: drug.available ? kMedicalBlueLight : Colors.grey[100],
        child: Icon(Icons.medication,
            color: drug.available ? kMedicalBlue : Colors.grey),
      ),
      title: Text(drug.nameAr,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        [
          if (drug.scientificName != null) drug.scientificName!,
          if (drug.form != null) drug.form!,
          if (drug.strength != null) drug.strength!,
        ].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: drug.available
              ? Colors.green.withValues(alpha:0.1)
              : Colors.orange.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          drug.available ? 'متوفر' : 'نادر',
          style: TextStyle(
              fontSize: 11,
              color: drug.available ? Colors.green[700] : Colors.orange[700],
              fontWeight: FontWeight.w600),
        ),
      ),
      onTap: onTap,
    );
  }
}
