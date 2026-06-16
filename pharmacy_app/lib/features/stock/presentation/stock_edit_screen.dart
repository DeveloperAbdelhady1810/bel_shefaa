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
          backgroundColor: Colors.green,
        ));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('تعديل المخزون')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Code lookup field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeCtrl,
                    focusNode: _codeFocus,
                    decoration: const InputDecoration(
                      labelText: 'باركود أو رقم EDA',
                      prefixIcon: Icon(Icons.qr_code),
                      hintText: 'امسح الباركود أو اكتب يدوياً',
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _lookup(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(56, 56)),
                  onPressed: state.isLooking ? null : _lookup,
                  child: state.isLooking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.search),
                ),
              ],
            ),

            // Error message
            if (state.error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(state.error!,
                    style: TextStyle(color: Colors.red[700])),
              ),
            ],

            // Drug result card + quantity editor
            if (state.result != null) ...[
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.medication,
                            color: kMedicalBlue, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.result!.nameAr,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ]),
                      if (state.result!.nameEn != null) ...[
                        const SizedBox(height: 4),
                        Text(state.result!.nameEn!,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13)),
                      ],
                      if (state.result!.form != null ||
                          state.result!.strength != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          [state.result!.form, state.result!.strength]
                              .whereType<String>()
                              .join(' — '),
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 13),
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextField(
                        controller: _qtyCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'الكمية المتاحة',
                          prefixIcon: Icon(Icons.inventory),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: state.isSaving ? null : _save,
                        icon: state.isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.save),
                        label: const Text('حفظ'),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const Spacer(),
            Text(
              'اسحب ماسح الباركود على علبة الدواء أو اكتب رقم EDA يدوياً.',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
