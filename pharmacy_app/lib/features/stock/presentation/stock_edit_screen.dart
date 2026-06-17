import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../application/stock_controller.dart';

class StockEditScreen extends ConsumerStatefulWidget {
  const StockEditScreen({super.key});

  @override
  ConsumerState<StockEditScreen> createState() => _StockEditScreenState();
}

class _StockEditScreenState extends ConsumerState<StockEditScreen> {
  final _codeCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _codeFocus = FocusNode();

  @override
  void dispose() {
    _codeCtrl.dispose();
    _qtyCtrl.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  Future<void> _lookup() async {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) return;
    await ref.read(stockControllerProvider.notifier).lookup(code);
    final result = ref.read(stockControllerProvider).result;
    if (result != null) {
      _qtyCtrl.text = result.quantity.toString();
    }
  }

  Future<void> _save() async {
    final result = ref.read(stockControllerProvider).result;
    if (result == null) return;
    final qty = int.tryParse(_qtyCtrl.text.trim()) ?? 0;
    await ref.read(stockControllerProvider.notifier).save(result.drugId, qty);
  }

  void _increment() {
    final current = int.tryParse(_qtyCtrl.text.trim()) ?? 0;
    _qtyCtrl.text = (current + 1).toString();
  }

  void _decrement() {
    final current = int.tryParse(_qtyCtrl.text.trim()) ?? 0;
    if (current > 0) _qtyCtrl.text = (current - 1).toString();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stockControllerProvider);

    // Show success snackbar once.
    ref.listen(stockControllerProvider, (prev, next) {
      if (next.successMessage != null &&
          next.successMessage != prev?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.successMessage!),
          backgroundColor: kSuccess,
        ));
      }
    });

    return Scaffold(
      backgroundColor: kBg,

      // ── Flat white AppBar (detail screen style) ──────────────────────────
      appBar: AppBar(
        backgroundColor: kSurface,
        foregroundColor: kDeepNavy,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تعديل المخزون',
          style: GoogleFonts.cairo(
            color: kDeepNavy,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: kDivider),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Search card ──────────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kDivider, width: 1),
                boxShadow: const [
                  BoxShadow(
                      color: kShadowBlue,
                      blurRadius: 20,
                      offset: Offset(0, 6)),
                  BoxShadow(
                      color: kShadowDeep,
                      blurRadius: 4,
                      offset: Offset(0, 2)),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codeCtrl,
                      focusNode: _codeFocus,
                      style: GoogleFonts.notoKufiArabic(
                          fontSize: 14, color: kTextPrimary),
                      decoration: const InputDecoration(
                        labelText: 'اسم الدواء أو الباركود أو رقم EDA',
                        hintText: 'مثال: بانادول أو الباركود',
                        prefixIcon: Icon(Icons.search_rounded),
                        suffixIcon: Icon(
                          Icons.qr_code_scanner_rounded,
                          color: kMedicalBlue,
                        ),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _lookup(),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Gradient search button
                  _TapScale(
                    onTap: state.isLooking ? () {} : _lookup,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [kMedicalBlue, kMedicalBlueDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: kMedicalBlue.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: state.isLooking ? null : _lookup,
                          child: Center(
                            child: state.isLooking
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white))
                                : const Icon(Icons.search_rounded,
                                    color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Error banner ──────────────────────────────────────────────────
            if (state.error != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: kErrorLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: kError.withValues(alpha: 0.35)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: kError, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.error!,
                        style: GoogleFonts.notoKufiArabic(
                            color: kError, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ── Drug result card ──────────────────────────────────────────────
            if (state.result != null) ...[
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kDivider, width: 1),
                  boxShadow: const [
                    BoxShadow(
                        color: kShadowBlue,
                        blurRadius: 20,
                        offset: Offset(0, 6)),
                    BoxShadow(
                        color: kShadowDeep,
                        blurRadius: 4,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drug identity
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: kMedicalBlueLight,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.medication_rounded,
                                color: kMedicalBlue, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.result!.nameAr,
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: kTextPrimary,
                                  ),
                                ),
                                if (state.result!.nameEn != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    state.result!.nameEn!,
                                    style: GoogleFonts.notoKufiArabic(
                                        color: kTextSecondary, fontSize: 13),
                                  ),
                                ],
                                if (state.result!.form != null ||
                                    state.result!.strength != null) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    [
                                      state.result!.form,
                                      state.result!.strength
                                    ]
                                        .whereType<String>()
                                        .join(' — '),
                                    style: GoogleFonts.notoKufiArabic(
                                        color: kTextSecondary, fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(height: 1, color: kDivider),
                      const SizedBox(height: 20),

                      // Current quantity display — large amber number
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'الكمية الحالية',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 13,
                                color: kTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${state.result!.quantity}',
                                  style: GoogleFonts.cairo(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: kAmber,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'وحدة',
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 14,
                                    color: kTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Divider(height: 1, color: kDivider),
                      const SizedBox(height: 20),

                      // Quantity stepper
                      Text(
                        'تحديث الكمية',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kMedicalBlue,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          // Decrement button
                          _StepperButton(
                            icon: Icons.remove_rounded,
                            onTap: _decrement,
                          ),
                          const SizedBox(width: 12),

                          // Qty text input
                          Expanded(
                            child: TextField(
                              controller: _qtyCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: kTextPrimary,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: kBg,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      const BorderSide(color: kDivider),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      const BorderSide(color: kDivider),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                      color: kMedicalBlue, width: 2),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 8),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Increment button
                          _StepperButton(
                            icon: Icons.add_rounded,
                            onTap: _increment,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Save button — full-width gradient
                      _TapScale(
                        onTap: state.isSaving ? () {} : _save,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [kMedicalBlue, kMedicalBlueDark],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: kMedicalBlue.withValues(alpha: 0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: state.isSaving ? null : _save,
                              child: Center(
                                child: state.isSaving
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white))
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.save_rounded,
                                              color: Colors.white, size: 20),
                                          const SizedBox(width: 8),
                                          Text(
                                            'حفظ الكمية',
                                            style: GoogleFonts.cairo(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const Spacer(),

            // ── Instruction hint ──────────────────────────────────────────────
            Text(
              'ابحث باسم الدواء أو امسح الباركود أو اكتب رقم EDA يدوياً.',
              style: GoogleFonts.notoKufiArabic(
                  color: kTextSecondary.withValues(alpha: 0.6),
                  fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Stepper button ─────────────────────────────────────────────────────────────
class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: kMedicalBlueLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kDivider, width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Icon(icon, color: kMedicalBlue, size: 26),
          ),
        ),
      ),
    );
  }
}

// ── Tap-scale micro-interaction ────────────────────────────────────────────────
class _TapScale extends StatefulWidget {
  const _TapScale({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 80));
  late final Animation<double> _scale = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: ScaleTransition(scale: _scale, child: widget.child),
      );
}
