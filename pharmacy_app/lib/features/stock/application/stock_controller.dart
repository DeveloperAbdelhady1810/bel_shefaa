import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/stock_repository.dart';

class StockState {
  const StockState({
    this.result,
    this.isLooking = false,
    this.isSaving = false,
    this.error,
    this.successMessage,
  });

  final DrugLookupResult? result;
  final bool isLooking;
  final bool isSaving;
  final String? error;
  final String? successMessage;

  StockState copyWith({
    DrugLookupResult? result,
    bool? isLooking,
    bool? isSaving,
    String? error,
    String? successMessage,
    bool clearResult = false,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return StockState(
      result: clearResult ? null : (result ?? this.result),
      isLooking: isLooking ?? this.isLooking,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

class StockController extends Notifier<StockState> {
  @override
  StockState build() => const StockState();

  Future<void> lookup(String code) async {
    state = state.copyWith(isLooking: true, clearError: true, clearSuccess: true, clearResult: true);
    try {
      final result = await ref.read(stockRepositoryProvider).lookup(code);
      state = state.copyWith(isLooking: false, result: result);
    } catch (e) {
      state = state.copyWith(isLooking: false, error: e.toString(), clearResult: true);
    }
  }

  Future<void> save(int drugId, int quantity) async {
    state = state.copyWith(isSaving: true, clearError: true, clearSuccess: true);
    try {
      await ref.read(stockRepositoryProvider).updateQuantity(drugId, quantity);
      state = state.copyWith(
        isSaving: false,
        successMessage: 'تم تحديث الكمية بنجاح.',
        result: state.result != null
            ? DrugLookupResult(
                drugId: state.result!.drugId,
                nameAr: state.result!.nameAr,
                nameEn: state.result!.nameEn,
                form: state.result!.form,
                strength: state.result!.strength,
                quantity: quantity,
              )
            : null,
      );
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
    }
  }
}

final stockControllerProvider =
    NotifierProvider<StockController, StockState>(StockController.new);
