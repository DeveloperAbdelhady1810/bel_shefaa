import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../application/orders_controller.dart';
import '../domain/incoming_order.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key, required this.order});

  final IncomingOrder order;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  bool _isLoading = false;

  Future<void> _accept() async {
    setState(() => _isLoading = true);
    try {
      final message = await ref
          .read(ordersControllerProvider.notifier)
          .acceptWithMessage(widget.order.orderId);

      if (!mounted) return;
      final won = !message.contains('أخرى');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: won ? Colors.green : Colors.orange,
      ));

      if (won) context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _reject() async {
    final reason = await showDialog<String?>(
      context: context,
      builder: (ctx) => _RejectDialog(),
    );
    if (reason == null) return; // cancelled

    setState(() => _isLoading = true);
    try {
      await ref
          .read(ordersControllerProvider.notifier)
          .reject(widget.order.orderId, reason: reason.isEmpty ? null : reason);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('تم رفض الطلب.'), backgroundColor: Colors.grey),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order.order;
    final drug = order?.drug;
    final address = order?.patientAddress;
    final patient = order?.patient;

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(
              icon: Icons.medication,
              title: 'الدواء',
              children: [
                _row('الاسم', drug?.nameAr ?? '—'),
                if (drug?.nameEn != null) _row('الاسم (EN)', drug!.nameEn),
                if (drug?.form != null) _row('الشكل', drug!.form!),
                if (drug?.strength != null) _row('التركيز', drug!.strength!),
                _row('الكمية', '${order?.quantity ?? '—'}'),
                if (order?.requiresPrescription == true)
                  _badge('يتطلب روشتة طبية', Colors.orange),
              ],
            ),
            const SizedBox(height: 16),
            _section(
              icon: Icons.location_on_outlined,
              title: 'العنوان',
              children: [
                _row('العنوان', address?.addressLine ?? '—'),
                if (address?.district != null)
                  _row('المنطقة', address!.district!),
                if (address?.city != null) _row('المدينة', address!.city!),
              ],
            ),
            const SizedBox(height: 16),
            _section(
              icon: Icons.person_outline,
              title: 'المريض',
              children: [
                _row('الاسم', patient?.name ?? '—'),
                if (patient?.phone != null) _row('الهاتف', patient!.phone!),
              ],
            ),
            const SizedBox(height: 16),
            _section(
              icon: Icons.payments_outlined,
              title: 'الدفع',
              children: [
                _row('طريقة الدفع',
                    order?.paymentMethod == 'cod' ? 'كاش عند الاستلام' : 'بطاقة'),
                if (order?.codAmount != null)
                  _row('المبلغ عند الاستلام',
                      '${order!.codAmount!.toStringAsFixed(2)} ج.م'),
                if (order?.deliveryFee != null)
                  _row('رسوم التوصيل',
                      '${order!.deliveryFee!.toStringAsFixed(2)} ج.م'),
              ],
            ),
            if (order?.notes != null) ...[
              const SizedBox(height: 16),
              _section(
                icon: Icons.notes,
                title: 'ملاحظات',
                children: [
                  Text(order!.notes!),
                ],
              ),
            ],
            const SizedBox(height: 32),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        minimumSize: const Size.fromHeight(52),
                      ),
                      onPressed: _accept,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('قبول', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        minimumSize: const Size.fromHeight(52),
                      ),
                      onPressed: _reject,
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('رفض', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, size: 20, color: kMedicalBlue),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15)),
            ]),
            const Divider(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 110,
              child: Text(label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13))),
          Expanded(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(text,
          style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _RejectDialog extends StatelessWidget {
  _RejectDialog();

  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('سبب الرفض'),
      content: TextField(
        controller: _ctrl,
        decoration:
            const InputDecoration(hintText: 'اختياري — اذكر السبب إن أردت'),
        maxLines: 3,
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء')),
        ElevatedButton(
            onPressed: () => Navigator.pop(context, _ctrl.text),
            child: const Text('تأكيد الرفض')),
      ],
    );
  }
}
