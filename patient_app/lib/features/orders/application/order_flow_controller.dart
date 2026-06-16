import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/domain/patient.dart';
import '../../drugs/domain/drug_result.dart';
import '../data/order_repository.dart';
import '../domain/order.dart';

class OrderFlowState {
  const OrderFlowState({
    this.drug,
    this.quantity = 1,
    this.selectedAddress,
    this.paymentMethod = 'cod',
    this.prescriptionImagePath,
    this.notes,
    this.isSubmitting = false,
    this.error,
    this.createdOrder,
  });

  final DrugResult? drug;
  final int quantity;
  final PatientAddress? selectedAddress;
  final String paymentMethod; // 'cod' | 'card'
  final String? prescriptionImagePath;
  final String? notes;
  final bool isSubmitting;
  final String? error;
  final Order? createdOrder;

  OrderFlowState copyWith({
    DrugResult? drug,
    int? quantity,
    PatientAddress? selectedAddress,
    String? paymentMethod,
    String? prescriptionImagePath,
    String? notes,
    bool? isSubmitting,
    String? error,
    Order? createdOrder,
    bool clearError = false,
    bool clearPrescription = false,
  }) =>
      OrderFlowState(
        drug: drug ?? this.drug,
        quantity: quantity ?? this.quantity,
        selectedAddress: selectedAddress ?? this.selectedAddress,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        prescriptionImagePath: clearPrescription
            ? null
            : (prescriptionImagePath ?? this.prescriptionImagePath),
        notes: notes ?? this.notes,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        error: clearError ? null : (error ?? this.error),
        createdOrder: createdOrder ?? this.createdOrder,
      );
}

class OrderFlowController extends Notifier<OrderFlowState> {
  @override
  OrderFlowState build() => const OrderFlowState();

  void init(DrugResult drug, {PatientAddress? defaultAddress}) {
    state = OrderFlowState(
      drug: drug,
      selectedAddress: defaultAddress,
    );
  }

  void setQuantity(int qty) => state = state.copyWith(quantity: qty.clamp(1, 99));
  void setAddress(PatientAddress address) =>
      state = state.copyWith(selectedAddress: address);
  void setPaymentMethod(String method) =>
      state = state.copyWith(paymentMethod: method);
  void setPrescription(String? path) =>
      state = state.copyWith(prescriptionImagePath: path);
  void setNotes(String? notes) => state = state.copyWith(notes: notes);

  Future<Order?> submit() async {
    if (state.drug == null || state.selectedAddress == null) return null;
    if (state.drug!.requiresPrescription &&
        state.prescriptionImagePath == null) {
      state =
          state.copyWith(error: 'يرجى إرفاق صورة الروشتة الطبية.');
      return null;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final order = await ref.read(orderRepositoryProvider).create(
            drugId: state.drug!.id,
            quantity: state.quantity,
            patientAddressId: state.selectedAddress!.id,
            paymentMethod: state.paymentMethod,
            notes: state.notes,
            prescriptionImagePath: state.prescriptionImagePath,
          );
      state = state.copyWith(isSubmitting: false, createdOrder: order);
      return order;
    } catch (e) {
      state =
          state.copyWith(isSubmitting: false, error: e.toString());
      return null;
    }
  }
}

final orderFlowControllerProvider =
    NotifierProvider<OrderFlowController, OrderFlowState>(
        OrderFlowController.new);
