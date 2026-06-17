import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _OrderFlowScreenState extends ConsumerState<OrderFlowScreen>
    with TickerProviderStateMixin {
  int _step = 0;

  late AnimationController _stepAnimCtrl;
  late Animation<double> _stepFade;
  late Animation<Offset> _stepSlide;

  @override
  void initState() {
    super.initState();
    _stepAnimCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280));
    _stepFade  = CurvedAnimation(parent: _stepAnimCtrl, curve: Curves.easeOut);
    _stepSlide = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _stepAnimCtrl, curve: Curves.easeOut));
    _stepAnimCtrl.forward();
  }

  @override
  void dispose() {
    _stepAnimCtrl.dispose();
    super.dispose();
  }

  void _animateToStep(int newStep) {
    _stepAnimCtrl.reset();
    setState(() => _step = newStep);
    _stepAnimCtrl.forward();
  }

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
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kSurface,
        foregroundColor: kDeepNavy,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          steps[_step],
          style: GoogleFonts.cairo(
              color: kDeepNavy, fontSize: 17, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kDeepNavy),
          onPressed: () {
            if (_step == 0) {
              context.pop();
            } else {
              _animateToStep(_step - 1);
            }
          },
        ),
      ),
      body: Column(
        children: [
          _StepIndicator(current: _step, total: totalSteps),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: FadeTransition(
                opacity: _stepFade,
                child: SlideTransition(
                  position: _stepSlide,
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
            ),
          ),

          if (flowState.error != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(flowState.error!,
                  style: GoogleFonts.notoKufiArabic(color: kError),
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
    final flowState  = ref.read(orderFlowControllerProvider);
    final controller = ref.read(orderFlowControllerProvider.notifier);

    if (_step < totalSteps - 1) {
      if (_step == 0 && flowState.quantity < 1) return;
      if (_step == 1 && flowState.selectedAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى اختيار عنوان التوصيل')),
        );
        return;
      }
      _animateToStep(_step + 1);
      return;
    }

    final order = await controller.submit();
    if (order == null) return;

    ref.read(ordersListControllerProvider.notifier).refresh();
    if (!mounted) return;

    if (flowState.paymentMethod == 'card') {
      context.pushReplacement('/payment/${order.id}');
    } else {
      context.pushReplacement('/tracking/${order.id}');
    }
  }
}

// ─── Step Indicator ───────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kSurface,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: List.generate(total * 2 - 1, (i) {
          if (i.isOdd) {
            final filled = i ~/ 2 < current;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 2,
                color: filled ? kMedicalBlue : kDivider,
              ),
            );
          }
          final stepIdx = i ~/ 2;
          final done   = stepIdx < current;
          final active = stepIdx == current;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: active ? 32 : 28,
            height: active ? 32 : 28,
            decoration: BoxDecoration(
              color: done
                  ? kSuccess
                  : active
                      ? kMedicalBlue
                      : kDivider,
              shape: BoxShape.circle,
              boxShadow: active
                  ? [
                      BoxShadow(
                          color: kAmber.withValues(alpha: 0.40),
                          blurRadius: 10,
                          offset: const Offset(0, 2))
                    ]
                  : null,
            ),
            child: Center(
              child: done
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : Text(
                      '${stepIdx + 1}',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: active ? Colors.white : kTextSecondary,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }
}

// ─── Bottom Bar ───────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.isLastStep,
    required this.isSubmitting,
    required this.onNext,
  });
  final bool isLastStep;
  final bool isSubmitting;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 14, 20, 14 + MediaQuery.paddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: kSurface,
        boxShadow: [
          BoxShadow(color: kShadowBlue, blurRadius: 16, offset: Offset(0, -4)),
          BoxShadow(color: kShadowDeep, blurRadius: 4, offset: Offset(0, -1)),
        ],
      ),
      child: _GradientButton(
        label: isLastStep ? 'تأكيد الطلب' : 'التالي',
        icon: isLastStep
            ? Icons.check_circle_outline
            : Icons.arrow_back_ios_new,
        loading: isSubmitting,
        onPressed: onNext,
      ),
    );
  }
}

// ─── Step 0: Confirm Drug ─────────────────────────────────────────────────────

class _StepConfirmDrug extends StatelessWidget {
  const _StepConfirmDrug({
    required this.drug,
    required this.quantity,
    required this.onQtyChanged,
  });
  final DrugResult drug;
  final int quantity;
  final ValueChanged<int> onQtyChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: kCardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kMedicalBlue, kMedicalBlueDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.medication_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(drug.nameAr,
                            style: GoogleFonts.cairo(
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                                color: kTextPrimary)),
                        if (drug.nameEn.isNotEmpty)
                          Text(drug.nameEn,
                              style: GoogleFonts.notoKufiArabic(
                                  color: kTextSecondary, fontSize: 13)),
                      ],
                    ),
                  ),
                  if (drug.requiresPrescription)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: kWarningLight,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('روشتة',
                          style: GoogleFonts.cairo(
                              fontSize: 11,
                              color: kWarning,
                              fontWeight: FontWeight.w700)),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: kDivider),
              const SizedBox(height: 10),
              if (drug.scientificName != null)
                _DetailRow('التركيب', drug.scientificName!),
              if (drug.form != null) _DetailRow('الشكل', drug.form!),
              if (drug.strength != null) _DetailRow('التركيز', drug.strength!),
              if (drug.officialPriceEgp != null)
                _PriceRow('السعر',
                    '${drug.officialPriceEgp!.toStringAsFixed(2)} ج.م'),
            ],
          ),
        ),

        const SizedBox(height: 28),

        Text('الكمية',
            style: GoogleFonts.cairo(
                fontWeight: FontWeight.w700, fontSize: 16, color: kTextPrimary)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _QtyButton(
                icon: Icons.remove,
                onTap: () => onQtyChanged(quantity - 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text('$quantity',
                  style: GoogleFonts.cairo(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: kAmber)),
            ),
            _QtyButton(
                icon: Icons.add,
                onTap: () => onQtyChanged(quantity + 1)),
          ],
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kMedicalBlue, kMedicalBlueDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: kMedicalBlue.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
                width: 80,
                child: Text(label,
                    style: GoogleFonts.notoKufiArabic(
                        color: kTextSecondary, fontSize: 13))),
            Expanded(
                child: Text(value,
                    style: GoogleFonts.notoKufiArabic(
                        fontSize: 13, color: kTextPrimary))),
          ],
        ),
      );
}

class _PriceRow extends StatelessWidget {
  const _PriceRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
                width: 80,
                child: Text(label,
                    style: GoogleFonts.notoKufiArabic(
                        color: kTextSecondary, fontSize: 13))),
            Text(value,
                style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: kAmber,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

// ─── Step 1: Address ──────────────────────────────────────────────────────────

class _StepAddress extends ConsumerWidget {
  const _StepAddress({required this.selected, required this.onSelected});
  final PatientAddress? selected;
  final ValueChanged<PatientAddress> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressControllerProvider);

    return addressesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) =>
          const Center(child: Text('تعذّر تحميل العناوين')),
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => onSelected(addr),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? kMedicalBlueLight : kSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? kMedicalBlue : kDivider,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: kShadowBlue,
                            blurRadius: 16,
                            offset: Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected ? kMedicalBlue : kTextSecondary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(addr.label,
                                  style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? kMedicalBlue
                                          : kTextPrimary)),
                              const SizedBox(height: 2),
                              Text(addr.addressLine,
                                  style: GoogleFonts.notoKufiArabic(
                                      color: kTextSecondary, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 4),
            OutlinedButton.icon(
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

// ─── Step 2: Prescription ─────────────────────────────────────────────────────

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
            color: kWarningLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kWarning.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: kWarning, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                    'هذا الدواء يستلزم روشتة طبية. يرجى رفع صورة الروشتة.',
                    style: GoogleFonts.notoKufiArabic(
                        color: kWarning, fontSize: 13)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        if (widget.imagePath != null) ...[
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kMedicalBlue, width: 2),
              image: DecorationImage(
                image: FileImage(File(widget.imagePath!)),
                fit: BoxFit.cover,
              ),
              boxShadow: const [
                BoxShadow(
                    color: kShadowBlue,
                    blurRadius: 16,
                    offset: Offset(0, 4)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('تغيير الصورة'),
            onPressed: _showSourceSheet,
          ),
        ] else ...[
          GestureDetector(
            onTap: _showSourceSheet,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: kMedicalBlueLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kMedicalBlue, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                        color: kMedicalBlueLight, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt_outlined,
                        color: kMedicalBlue, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text('اضغط لرفع صورة الروشتة',
                      style: GoogleFonts.cairo(
                          color: kMedicalBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('كاميرا أو معرض الصور',
                      style: GoogleFonts.notoKufiArabic(
                          color: kTextSecondary, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                    color: kMedicalBlueLight,
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.camera_alt, color: kMedicalBlue),
              ),
              title: Text('الكاميرا',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                    color: kSuccessLight,
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.photo_library, color: kSuccess),
              ),
              title: Text('المعرض',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 3: Payment ──────────────────────────────────────────────────────────

class _StepPayment extends StatelessWidget {
  const _StepPayment({
    required this.method,
    required this.onChanged,
    required this.codAmount,
  });
  final String method;
  final ValueChanged<String> onChanged;
  final double? codAmount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('اختر طريقة الدفع',
            style: GoogleFonts.cairo(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: kTextPrimary)),
        const SizedBox(height: 16),
        _PaymentOption(
          value: 'cod',
          groupValue: method,
          onChanged: onChanged,
          icon: Icons.money_rounded,
          title: 'كاش عند الاستلام',
          subtitle: codAmount != null
              ? 'ستدفع ${codAmount!.toStringAsFixed(2)} ج.م + رسوم توصيل'
              : 'الدفع عند وصول الدواء',
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          value: 'card',
          groupValue: method,
          onChanged: onChanged,
          icon: Icons.credit_card_rounded,
          title: 'بطاقة بنكية',
          subtitle: 'ادفع الآن بأمان عبر Paymob',
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? kMedicalBlueLight : kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: selected ? kMedicalBlue : kDivider,
              width: selected ? 2 : 1),
          boxShadow: const [
            BoxShadow(color: kShadowBlue, blurRadius: 16, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: selected ? kMedicalBlue : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon,
                  color: selected ? Colors.white : kTextSecondary, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: selected ? kMedicalBlue : kTextPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: GoogleFonts.notoKufiArabic(
                          fontSize: 12, color: kTextSecondary)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? kMedicalBlue : kTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Gradient Button ──────────────────────────────────────────────────────────

class _GradientButton extends StatefulWidget {
  const _GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.color1 = kMedicalBlue,
    this.color2 = kMedicalBlueDark,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool loading;
  final Color color1;
  final Color color2;

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
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
          onTapDown: (_) { if (!widget.loading) _ctrl.forward(); },
          onTapUp: (_) {
            _ctrl.reverse();
            if (!widget.loading) widget.onPressed();
          },
          onTapCancel: () => _ctrl.reverse(),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color1, widget.color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.color1.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: widget.loading
                  ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(widget.label,
                            style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                      ],
                    ),
            ),
          ),
        ),
      );
}
