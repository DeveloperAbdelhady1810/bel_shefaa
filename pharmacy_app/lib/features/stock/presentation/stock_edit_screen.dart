import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      appBar: AppBar(
        title: const Text('تعديل المخزون'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kMedicalBlue, kMedicalBlueDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Search card ──────────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codeCtrl,
                      focusNode: _codeFocus,
                      decoration: const InputDecoration(
                        labelText: 'اسم الدواء أو الباركود أو رقم EDA',
                        prefixIcon: Icon(Icons.qr_code_scanner_outlined),
                        hintText: 'مثال: بانادول أو الباركود',
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
                                : const Icon(Icons.search,
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
                  color: kError.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: kError.withValues(alpha: 0.35)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: kError, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.error!,
                        style:
                            const TextStyle(color: kError, fontSize: 13),
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
                decoration: const BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
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
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: kMedicalBlueLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.medication,
                                color: kMedicalBlue, size: 26),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.result!.nameAr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: kTextPrimary,
                                  ),
                                ),
                                if (state.result!.nameEn != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    state.result!.nameEn!,
                                    style: const TextStyle(
                                        color: kTextSecondary,
                                        fontSize: 13),
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
                                    style: const TextStyle(
                                        color: kTextSecondary,
                                        fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Container(height: 1, color: kBg),
                      const SizedBox(height: 16),

                      // Quantity field
                      TextField(
                        controller: _qtyCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'الكمية المتاحة',
                          prefixIcon:
                              Icon(Icons.inventory_2_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Save button (full-width gradient)
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
                                color:
                                    kMedicalBlue.withValues(alpha: 0.35),
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
                                    : const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.save_outlined,
                                              color: Colors.white,
                                              size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'حفظ الكمية',
                                            style: TextStyle(
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
              style: TextStyle(
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
      vsync: this, duration: const Duration(milliseconds: 90));
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
