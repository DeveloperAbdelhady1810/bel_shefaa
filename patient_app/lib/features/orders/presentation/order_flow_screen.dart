import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../address/application/address_controller.dart';
import '../../auth/domain/patient.dart';
import '../../drugs/domain/drug_result.dart';
import '../application/order_flow_controller.dart';
import '../application/order_tracking_controller.dart';

class OrderFlowScreen extends ConsumerStatefulWidget {
  const OrderFlowScreen({super.key});

  @override
  ConsumerState<OrderFlowScreen> createState() => _OrderFlowScreenState();
}

class _OrderFlowScreenState extends ConsumerState<OrderFlowScreen> {
  int _step = 0; // 0=confirm, 1=address, 2=prescription(optional), 3=payment

  @override
  Widget build(BuildContext context) {
    final flowState = ref.watch(orderFlowControllerProvider);
    final controller = ref.read(orderFlowControllerProvider.notifier);
    final drug = flowState.drug;
    if (drug == null) {
      return const Scaffold(body: Center(child: Text('خطأ في البيانات')));
    }

    final steps = [
      'تأكيد الدواء',
      'العنوان',
      if (drug.requiresPrescription) 'الروشتة',
      'الدفع',
    ];
    final totalSteps = steps.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(steps[_step]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_step == 0) {
              context.pop();
            } else {
              setState(() => _step--);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_step + 1) / totalSteps,
            backgroundColor: Colors.grey[200],
            color: kMedicalBlue,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: [
                _StepConfirmDrug(
                  drug: drug,
                  quantity: flowState.quantity,
                  onQtyChanged: controller.setQuantity,
                ),
                _StepAddress(
                  selected: flowState.selectedAddress,
                  onSelected: controller.setAddress,
                ),
                if (drug.requiresPrescription)
                  _StepPrescription(
                    imagePath: flowState.prescriptionImagePath,
                    onPicked: controller.setPrescription,
                  ),
                _StepPayment(
                  method: flowState.paymentMethod,
                  onChanged: controller.setPaymentMethod,
                  codAmount: drug.officialPriceEgp,
                ),
              ][_step],
            ),
          ),
          if (flowState.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(flowState.error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center),
            ),
          _BottomBar(
            isLastStep: _step == totalSteps - 1,
            isSubmitting: flowState.isSubmitting,
            onNext: () => _onNext(totalSteps, drug.requiresPrescription),
          ),
        ],
      ),
    );
  }

  void _onNext(int totalSteps, bool requiresPrescription) async {
    final flowState = ref.read(orderFlowControllerProvider);
    final controller = ref.read(orderFlowControllerProvider.notifier);

    if (_step < totalSteps - 1) {
      // Validate current step
      if (_step == 0 && flowState.quantity < 1) return;
      if (_step == 1 && flowState.selectedAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى اختيار عنوان التوصيل')),
        );
        return;
      }
      setState(() => _step++);
      return;
    }

    // Last step — submit
    final order = await controller.submit();
    if (order == null) return; // error set in state

    // Refresh orders list
    ref.read(ordersListControllerProvider.notifier).refresh();

    if (!mounted) return;

    if (flowState.paymentMethod == 'card') {
      context.pushReplacement('/payment/${order.id}');
    } else {
      context.pushReplacement('/tracking/${order.id}');
    }
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar(
      {required this.isLastStep,
      required this.isSubmitting,
      required this.onNext});
  final bool isLastStep;
  final bool isSubmitting;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 8,
              offset: const Offset(0, -2))
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: isSubmitting
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: onNext,
                child: Text(isLastStep ? 'تأكيد الطلب' : 'التالي'),
              ),
      ),
    );
  }
}

// ─── Step 0: Confirm drug ────────────────────────────────────────────────────

class _StepConfirmDrug extends StatelessWidget {
  const _StepConfirmDrug(
      {required this.drug, required this.quantity, required this.onQtyChanged});
  final DrugResult drug;
  final int quantity;
  final ValueChanged<int> onQtyChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: kMedicalBlueLight,
                      child: Icon(Icons.medication, color: kMedicalBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(drug.nameAr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16)),
                          if (drug.nameEn.isNotEmpty)
                            Text(drug.nameEn,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13)),
                        ],
                      ),
                    ),
                    if (drug.requiresPrescription)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('روشتة',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange,
                                fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
                const Divider(height: 20),
                if (drug.scientificName != null)
                  _DetailRow('التركيب', drug.scientificName!),
                if (drug.form != null) _DetailRow('الشكل', drug.form!),
                if (drug.strength != null) _DetailRow('التركيز', drug.strength!),
                if (drug.officialPriceEgp != null)
                  _DetailRow('السعر',
                      '${drug.officialPriceEgp!.toStringAsFixed(2)} ج.م'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('الكمية',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filled(
              onPressed: () => onQtyChanged(quantity - 1),
              icon: const Icon(Icons.remove),
              style: IconButton.styleFrom(backgroundColor: kMedicalBlue),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('$quantity',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w700)),
            ),
            IconButton.filled(
              onPressed: () => onQtyChanged(quantity + 1),
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(backgroundColor: kMedicalBlue),
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
              width: 80,
              child: Text(label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13))),
          Expanded(
              child:
                  Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

// ─── Step 1: Address ─────────────────────────────────────────────────────────

class _StepAddress extends ConsumerWidget {
  const _StepAddress({required this.selected, required this.onSelected});
  final PatientAddress? selected;
  final ValueChanged<PatientAddress> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressControllerProvider);

    return addressesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('تعذّر تحميل العناوين')),
      data: (addresses) {
        if (addresses.isEmpty) {
          return Column(
            children: [
              const Text('لا توجد عناوين محفوظة.'),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.add_location_alt_outlined),
                label: const Text('إضافة عنوان'),
                onPressed: () => context.push('/onboarding-address'),
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...addresses.map((addr) {
              final isSelected = selected?.id == addr.id;
              return Card(
                color: isSelected ? kMedicalBlueLight : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                      color: isSelected ? kMedicalBlue : Colors.transparent,
                      width: 2),
                ),
                child: ListTile(
                  onTap: () => onSelected(addr),
                  leading: Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isSelected ? kMedicalBlue : Colors.grey,
                  ),
                  title: Text(addr.label,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(addr.addressLine),
                ),
              );
            }),
            const SizedBox(height: 12),
            TextButton.icon(
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('إضافة عنوان جديد'),
              onPressed: () => context.push('/onboarding-address'),
            ),
          ],
        );
      },
    );
  }
}

// ─── Step 2: Prescription (optional step) ────────────────────────────────────

class _StepPrescription extends StatefulWidget {
  const _StepPrescription({required this.imagePath, required this.onPicked});
  final String? imagePath;
  final ValueChanged<String?> onPicked;

  @override
  State<_StepPrescription> createState() => _StepPrescriptionState();
}

class _StepPrescriptionState extends State<_StepPrescription> {
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 80);
    if (file != null) widget.onPicked(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha:0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                    'هذا الدواء يستلزم روشتة طبية. يرجى رفع صورة الروشتة.',
                    style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (widget.imagePath != null) ...[
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kMedicalBlue),
              image: DecorationImage(
                image: FileImage(File(widget.imagePath!)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('تغيير الصورة'),
            onPressed: () => _showSourceSheet(),
          ),
        ] else ...[
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('التقاط صورة من الكاميرا'),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('اختيار من المعرض'),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ],
    );
  }

  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('الكاميرا'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('المعرض'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}

// ─── Step 3: Payment ─────────────────────────────────────────────────────────

class _StepPayment extends StatelessWidget {
  const _StepPayment(
      {required this.method,
      required this.onChanged,
      required this.codAmount});
  final String method;
  final ValueChanged<String> onChanged;
  final double? codAmount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('اختر طريقة الدفع',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        _PaymentOption(
          value: 'cod',
          groupValue: method,
          onChanged: onChanged,
          icon: Icons.money,
          title: 'كاش عند الاستلام',
          subtitle: codAmount != null
              ? 'ستدفع ${codAmount!.toStringAsFixed(2)} ج.م + رسوم توصيل'
              : 'الدفع عند وصول الدواء',
        ),
        const SizedBox(height: 10),
        _PaymentOption(
          value: 'card',
          groupValue: method,
          onChanged: onChanged,
          icon: Icons.credit_card,
          title: 'بطاقة بنكية',
          subtitle: 'ادفع الآن بأمان عبر Paymob',
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption(
      {required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.icon,
      required this.title,
      required this.subtitle});
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? kMedicalBlueLight : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? kMedicalBlue : Colors.grey[300]!, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? kMedicalBlue : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selected ? kMedicalBlue : null)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? kMedicalBlue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
