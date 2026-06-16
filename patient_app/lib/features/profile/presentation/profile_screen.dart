import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../address/application/address_controller.dart';
import '../../auth/application/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authControllerProvider);
    final patient = authAsync.valueOrNull is AuthAuthenticated
        ? (authAsync.valueOrNull! as AuthAuthenticated).patient
        : null;

    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          // ── Gradient header ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kMedicalBlueDark, kMedicalBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            size: 44, color: kMedicalBlue),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        patient?.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (patient?.email != null) ...[
                        const SizedBox(height: 4),
                        Text(patient!.email!,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 13)),
                      ],
                      if (patient?.phone != null) ...[
                        const SizedBox(height: 2),
                        Text(patient!.phone!,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 13)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Content (overlapping gradient with negative margin) ────
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  children: [
                    // ── Addresses section ──────────────────────────
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              'عناوين التوصيل',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: kTextPrimary),
                            ),
                          ),
                          _AddressesList(),
                          // Add address (dashed)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                            child: GestureDetector(
                              onTap: () =>
                                  context.push('/onboarding-address'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: kMedicalBlue.withValues(alpha: 0.4),
                                      width: 1.5,
                                      strokeAlign:
                                          BorderSide.strokeAlignInside),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_location_alt_outlined,
                                        color: kMedicalBlue, size: 20),
                                    SizedBox(width: 8),
                                    Text('إضافة عنوان جديد',
                                        style: TextStyle(
                                            color: kMedicalBlue,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Menu items section ─────────────────────────
                    _SectionCard(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: kMedicalBlueLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.receipt_long_outlined,
                                  color: kMedicalBlue, size: 20),
                            ),
                            title: const Text('سجل طلباتي',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: kTextPrimary)),
                            trailing: const Icon(Icons.chevron_right,
                                color: kTextSecondary),
                            onTap: () => context.push('/orders-history'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Logout section ─────────────────────────────
                    _SectionCard(
                      child: ListTile(
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: kError.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.logout,
                              color: kError, size: 20),
                        ),
                        title: const Text('تسجيل الخروج',
                            style: TextStyle(
                                color: kError, fontWeight: FontWeight.w600)),
                        onTap: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('تسجيل الخروج'),
                              content: const Text(
                                  'هل تريد تسجيل الخروج من حسابك؟'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('إلغاء')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('خروج',
                                        style:
                                            TextStyle(color: kError))),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await ref
                                .read(authControllerProvider.notifier)
                                .logout();
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

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
      child: child,
    );
  }
}

// ─── Addresses List ───────────────────────────────────────────────────────────

class _AddressesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressControllerProvider);
    return addressesAsync.when(
      loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Padding(
          padding: EdgeInsets.all(16),
          child: Text('تعذّر تحميل العناوين',
              style: TextStyle(color: kTextSecondary))),
      data: (addresses) {
        if (addresses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('لا توجد عناوين محفوظة',
                style: TextStyle(color: kTextSecondary)),
          );
        }
        return Column(
          children: addresses
              .map((addr) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: kBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: kMedicalBlue, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(addr.label,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: kTextPrimary,
                                        fontSize: 13)),
                                Text(addr.addressLine,
                                    style: const TextStyle(
                                        color: kTextSecondary,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: kError, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('حذف العنوان'),
                                  content: const Text(
                                      'هل تريد حذف هذا العنوان نهائياً؟'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('إلغاء')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('حذف',
                                            style:
                                                TextStyle(color: kError))),
                                  ],
                                ),
                              );
                              if (ok == true) {
                                await ref
                                    .read(addressControllerProvider.notifier)
                                    .delete(addr.id);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
