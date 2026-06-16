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
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: ListView(
        children: [
          // Avatar / name header
          Container(
            color: kMedicalBlue,
            padding:
                const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 36, color: kMedicalBlue),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patient?.name ?? '',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    if (patient?.email != null)
                      Text(patient!.email!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                    if (patient?.phone != null)
                      Text(patient!.phone!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Addresses section
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('عناوين التوصيل',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
          ),
          _AddressesList(),
          ListTile(
            leading: const Icon(Icons.add_location_alt_outlined,
                color: kMedicalBlue),
            title: const Text('إضافة عنوان جديد'),
            onTap: () => context.push('/onboarding-address'),
          ),

          const Divider(height: 24),

          // Orders
          ListTile(
            leading:
                const Icon(Icons.receipt_long_outlined, color: kMedicalBlue),
            title: const Text('سجل طلباتي'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/orders-history'),
          ),

          const Divider(height: 8),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('تسجيل الخروج',
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('تسجيل الخروج'),
                  content:
                      const Text('هل تريد تسجيل الخروج من حسابك؟'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('إلغاء')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('خروج',
                            style: TextStyle(color: Colors.red))),
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
        ],
      ),
    );
  }
}

class _AddressesList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressControllerProvider);
    return addressesAsync.when(
      loading: () =>
          const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Padding(
          padding: EdgeInsets.all(16),
          child: Text('تعذّر تحميل العناوين')),
      data: (addresses) {
        if (addresses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('لا توجد عناوين محفوظة',
                style: TextStyle(color: Colors.grey)),
          );
        }
        return Column(
          children: addresses
              .map((addr) => ListTile(
                    leading: const Icon(Icons.location_on_outlined,
                        color: kMedicalBlue),
                    title: Text(addr.label,
                        style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(addr.addressLine),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red),
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
                                      style: TextStyle(
                                          color: Colors.red))),
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
                  ))
              .toList(),
        );
      },
    );
  }
}
