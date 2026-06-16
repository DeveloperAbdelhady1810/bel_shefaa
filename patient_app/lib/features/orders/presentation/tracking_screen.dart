import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/order_tracking_controller.dart';
import '../domain/order.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key, required this.orderId});
  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderTrackingProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الطلب')),
      body: orderAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text(e.toString(),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center),
              TextButton(
                onPressed: () =>
                    ref.invalidate(orderTrackingProvider(orderId)),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
        data: (order) => _OrderTrackingBody(order: order),
      ),
    );
  }
}

class _OrderTrackingBody extends StatelessWidget {
  const _OrderTrackingBody({required this.order});
  final Order order;

  static const _steps = [
    'جارٍ البحث',
    'تم القبول / التحضير',
    'في الطريق',
    'تم التوصيل',
  ];

  @override
  Widget build(BuildContext context) {
    final stepIndex = order.status.stepIndex;
    final isTerminal = order.status.isTerminal;
    final isCancelled =
        order.status == 'cancelled' || order.status == 'failed';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: isCancelled
                  ? Colors.red.withValues(alpha:0.1)
                  : kMedicalBlueLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCancelled
                      ? Icons.cancel_outlined
                      : isTerminal
                          ? Icons.check_circle_outline
                          : Icons.access_time,
                  color: isCancelled
                      ? Colors.red
                      : isTerminal
                          ? Colors.green
                          : kMedicalBlue,
                ),
                const SizedBox(width: 8),
                Text(order.status.label,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isCancelled
                            ? Colors.red
                            : isTerminal
                                ? Colors.green
                                : kMedicalBlue)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stepper
          if (!isCancelled) ...[
            _TrackingStepper(steps: _steps, currentStep: stepIndex),
            const SizedBox(height: 24),
          ],

          // Drug info card
          _InfoCard(
            title: 'الدواء',
            icon: Icons.medication,
            children: [
              _InfoRow(
                  'الاسم', order.drug?.nameAr ?? 'دواء #${order.drugId}'),
              _InfoRow('الكمية', '${order.quantity}'),
              if (order.codAmount != null)
                _InfoRow('السعر',
                    '${order.codAmount!.toStringAsFixed(2)} ج.م'),
              if (order.deliveryFee != null)
                _InfoRow('رسوم التوصيل',
                    '${order.deliveryFee!.toStringAsFixed(2)} ج.م'),
            ],
          ),
          const SizedBox(height: 12),

          // Pharmacy card (if assigned)
          if (order.pharmacy != null) ...[
            _InfoCard(
              title: 'الصيدلية',
              icon: Icons.store_outlined,
              children: [
                _InfoRow('الاسم', order.pharmacy!.name),
                if (order.pharmacy!.phone != null)
                  _InfoRow('الهاتف', order.pharmacy!.phone!),
                if (order.pharmacy!.address != null)
                  _InfoRow('العنوان', order.pharmacy!.address!),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Payment
          _InfoCard(
            title: 'الدفع',
            icon: Icons.payment_outlined,
            children: [
              _InfoRow(
                  'طريقة الدفع',
                  order.paymentMethod == 'cod'
                      ? 'كاش عند الاستلام'
                      : 'بطاقة بنكية'),
              _InfoRow(
                  'حالة الدفع',
                  order.paymentStatus == 'paid'
                      ? 'مدفوع'
                      : order.paymentStatus == 'refunded'
                          ? 'مسترد'
                          : 'معلق'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrackingStepper extends StatelessWidget {
  const _TrackingStepper(
      {required this.steps, required this.currentStep});
  final List<String> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // connector
          final stepBefore = i ~/ 2;
          final filled = stepBefore < currentStep;
          return Expanded(
            child: Container(
              height: 2,
              color: filled ? kMedicalBlue : Colors.grey[300],
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final done = stepIndex < currentStep;
        final active = stepIndex == currentStep;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: done
                  ? kMedicalBlue
                  : active
                      ? kMedicalBlue.withValues(alpha:0.3)
                      : Colors.grey[200],
              child: done
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : active
                      ? const CircleAvatar(
                          radius: 6, backgroundColor: kMedicalBlue)
                      : CircleAvatar(
                          radius: 6, backgroundColor: Colors.grey[400]),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 60,
              child: Text(steps[stepIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 9,
                      color: (done || active)
                          ? kMedicalBlue
                          : Colors.grey[500])),
            ),
          ],
        );
      }),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard(
      {required this.title,
      required this.icon,
      required this.children});
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: kMedicalBlue),
                const SizedBox(width: 6),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: kMedicalBlue)),
              ],
            ),
            const Divider(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 100,
              child: Text(label,
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: 13))),
          Expanded(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
