import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
            ? (authState.value as AuthAuthenticated).user.pharmacy?.name ?? 'الصيدلية'
            : 'الصيدلية';

    final ordersAsync = ref.watch(ordersControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(pharmacyName),
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'تعديل المخزون',
            onPressed: () => context.push('/stock'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(ordersControllerProvider.notifier).refresh(),
        child: ordersAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                Text(e.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () =>
                      ref.read(ordersControllerProvider.notifier).refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
          data: (orders) {
            if (orders.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('لا توجد طلبات واردة',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                    SizedBox(height: 8),
                    Text('اسحب للأسفل للتحديث',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  _OrderCard(order: orders[i]),
            );
          },
        ),
      ),
    );
  }
}

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
    final expiry = DateTime.tryParse(widget.order.expiresAt!) ?? DateTime.now();
    final diff = expiry.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  String get _countdownText {
    if (_remaining == Duration.zero) return 'انتهت المهلة';
    final m = _remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Color get _countdownColor {
    if (_remaining.inSeconds <= 30) return Colors.red;
    if (_remaining.inSeconds <= 60) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order.order;
    final drug = order?.drug;
    final address = order?.patientAddress;

    return InkWell(
      onTap: () => context.push('/orders/detail', extra: widget.order),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      drug?.nameAr ?? '—',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _countdownColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _countdownColor),
                    ),
                    child: Text(_countdownText,
                        style: TextStyle(
                            color: _countdownColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                ],
              ),
              if (drug?.form != null || drug?.strength != null) ...[
                const SizedBox(height: 4),
                Text(
                  [drug?.form, drug?.strength]
                      .whereType<String>()
                      .join(' — '),
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.numbers, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('الكمية: ${order?.quantity ?? '—'}'),
                  const SizedBox(width: 16),
                  if (order?.requiresPrescription == true) ...[
                    Icon(Icons.receipt_long, size: 16, color: Colors.orange[700]),
                    const SizedBox(width: 4),
                    Text('يتطلب روشتة',
                        style: TextStyle(
                            color: Colors.orange[700], fontSize: 13)),
                  ],
                ],
              ),
              if (address != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: kMedicalBlue),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        [address.district, address.city]
                            .whereType<String>()
                            .join('، '),
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('اضغط لعرض التفاصيل',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios,
                      size: 12, color: Colors.grey[500]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
