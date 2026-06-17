import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
          // ── Gradient header (tall) ─────────────────────────────────
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
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 52),
                  child: Column(
                    children: [
                      // Premium avatar with amber ring
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outermost: gradient blue ring
                          Container(
                            width: 100, height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [kMedicalBlueLight, kMedicalBlue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          // White gap ring
                          Container(
                            width: 92, height: 92,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Amber ring
                          Container(
                            width: 88, height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: kAmber, width: 2.5),
                            ),
                          ),
                          // White inner
                          Container(
                            width: 82, height: 82,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person_rounded,
                                size: 44, color: kMedicalBlue),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        patient?.name ?? '',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (patient?.email != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          patient!.email!,
                          style: GoogleFonts.notoKufiArabic(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13),
                        ),
                      ],
                      if (patient?.phone != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          patient!.phone!,
                          style: GoogleFonts.notoKufiArabic(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Content overlapping gradient ───────────────────────────
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  children: [
                    // Addresses section
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              'عناوين التوصيل',
                              style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: kTextPrimary),
                            ),
                          ),
                          _AddressesList(),
                          // Add address button (solid border as Flutter
                          // doesn't support true dashed borders)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                            child: GestureDetector(
                              onTap: () =>
                                  context.push('/onboarding-address'),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: kMedicalBlueLight.withValues(
                                      alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: kMedicalBlue
                                          .withValues(alpha: 0.45),
                                      width: 1.5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                        Icons.add_location_alt_outlined,
                                        color: kMedicalBlue, size: 20),
                                    const SizedBox(width: 8),
                                    Text('إضافة عنوان جديد',
                                        style: GoogleFonts.cairo(
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

                    // Menu items
                    _SectionCard(
                      child: Column(
                        children: [
                          _MenuItem(
                            icon: Icons.receipt_long_outlined,
                            iconBgColor: kMedicalBlueLight,
                            iconColor: kMedicalBlue,
                            title: 'سجل طلباتي',
                            onTap: () => context.push('/orders-history'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Logout
                    _SectionCard(
                      child: _MenuItem(
                        icon: Icons.logout,
                        iconBgColor: kErrorLight,
                        iconColor: kError,
                        title: 'تسجيل الخروج',
                        titleColor: kError,
                        onTap: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('تسجيل الخروج',
                                  style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.w700)),
                              content: Text(
                                  'هل تريد تسجيل الخروج من حسابك؟',
                                  style: GoogleFonts.notoKufiArabic()),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('إلغاء')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text('خروج',
                                        style: GoogleFonts.cairo(
                                            color: kError))),
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

// ─── Menu Item ────────────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.titleColor,
  });
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title,
          style: GoogleFonts.cairo(
              fontWeight: FontWeight.w600,
              color: titleColor ?? kTextPrimary)),
      trailing: Icon(Icons.chevron_right, color: kTextSecondary),
      onTap: onTap,
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
      decoration: kCardDecoration(),
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
      error: (_, __) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('تعذّر تحميل العناوين',
              style: GoogleFonts.notoKufiArabic(color: kTextSecondary))),
      data: (addresses) {
        if (addresses.isEmpty) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('لا توجد عناوين محفوظة',
                style: GoogleFonts.notoKufiArabic(color: kTextSecondary)),
          );
        }
        return Column(
          children: addresses
              .map((addr) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: kBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kDivider),
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
                                    style: GoogleFonts.cairo(
                                        fontWeight: FontWeight.w600,
                                        color: kTextPrimary,
                                        fontSize: 13)),
                                Text(addr.addressLine,
                                    style: GoogleFonts.notoKufiArabic(
                                        color: kTextSecondary, fontSize: 12)),
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
                                  title: Text('حذف العنوان',
                                      style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.w700)),
                                  content: Text(
                                      'هل تريد حذف هذا العنوان نهائياً؟',
                                      style: GoogleFonts.notoKufiArabic()),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('إلغاء')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text('حذف',
                                            style: GoogleFonts.cairo(
                                                color: kError))),
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
