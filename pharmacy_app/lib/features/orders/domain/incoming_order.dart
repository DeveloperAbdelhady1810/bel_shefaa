// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_order.freezed.dart';
part 'incoming_order.g.dart';

double? _parseDouble(dynamic v) =>
    v == null ? null : double.tryParse(v.toString());

int _parseInt(dynamic v) =>
    v == null ? 0 : int.tryParse(v.toString()) ?? 0;

@freezed
class IncomingDrug with _$IncomingDrug {
  const factory IncomingDrug({
    @JsonKey(fromJson: _parseInt) required int id,
    @JsonKey(name: 'name_ar') required String nameAr,
    @JsonKey(name: 'name_en') required String nameEn,
    String? form,
    String? strength,
    String? unit,
    @JsonKey(name: 'requires_prescription')
    @Default(false)
    bool requiresPrescription,
  }) = _IncomingDrug;

  factory IncomingDrug.fromJson(Map<String, dynamic> json) =>
      _$IncomingDrugFromJson(json);
}

@freezed
class IncomingAddress with _$IncomingAddress {
  const factory IncomingAddress({
    @JsonKey(fromJson: _parseInt) required int id,
    @JsonKey(name: 'address_line') required String addressLine,
    String? city,
    String? district,
    @JsonKey(fromJson: _parseDouble) double? lat,
    @JsonKey(fromJson: _parseDouble) double? lng,
  }) = _IncomingAddress;

  factory IncomingAddress.fromJson(Map<String, dynamic> json) =>
      _$IncomingAddressFromJson(json);
}

@freezed
class IncomingPatient with _$IncomingPatient {
  const factory IncomingPatient({
    @JsonKey(fromJson: _parseInt) required int id,
    required String name,
    String? phone,
  }) = _IncomingPatient;

  factory IncomingPatient.fromJson(Map<String, dynamic> json) =>
      _$IncomingPatientFromJson(json);
}

@freezed
class IncomingOrderDetail with _$IncomingOrderDetail {
  const factory IncomingOrderDetail({
    @JsonKey(fromJson: _parseInt) required int id,
    @JsonKey(name: 'drug_id', fromJson: _parseInt) required int drugId,
    @JsonKey(fromJson: _parseInt) required int quantity,
    String? notes,
    @JsonKey(name: 'prescription_image') String? prescriptionImage,
    @JsonKey(name: 'requires_prescription')
    @Default(false)
    bool requiresPrescription,
    @JsonKey(name: 'cod_amount', fromJson: _parseDouble) double? codAmount,
    @JsonKey(name: 'delivery_fee', fromJson: _parseDouble) double? deliveryFee,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    IncomingDrug? drug,
    @JsonKey(name: 'patient_address') IncomingAddress? patientAddress,
    IncomingPatient? patient,
  }) = _IncomingOrderDetail;

  factory IncomingOrderDetail.fromJson(Map<String, dynamic> json) =>
      _$IncomingOrderDetailFromJson(json);
}

@freezed
class IncomingOrder with _$IncomingOrder {
  const factory IncomingOrder({
    @JsonKey(fromJson: _parseInt) required int id,
    @JsonKey(name: 'order_id', fromJson: _parseInt) required int orderId,
    @JsonKey(name: 'pharmacy_id', fromJson: _parseInt) required int pharmacyId,
    required String status,
    @JsonKey(name: 'sent_at') String? sentAt,
    @JsonKey(name: 'expires_at') String? expiresAt,
    IncomingOrderDetail? order,
  }) = _IncomingOrder;

  factory IncomingOrder.fromJson(Map<String, dynamic> json) =>
      _$IncomingOrderFromJson(json);
}
