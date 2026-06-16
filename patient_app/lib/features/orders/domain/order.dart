// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class OrderDrug with _$OrderDrug {
  const factory OrderDrug({
    required int id,
    @JsonKey(name: 'name_ar') required String nameAr,
    @JsonKey(name: 'name_en') String? nameEn,
    String? form,
    String? strength,
  }) = _OrderDrug;
  factory OrderDrug.fromJson(Map<String, dynamic> json) =>
      _$OrderDrugFromJson(json);
}

@freezed
class OrderPharmacy with _$OrderPharmacy {
  const factory OrderPharmacy({
    required int id,
    required String name,
    String? phone,
    String? address,
  }) = _OrderPharmacy;
  factory OrderPharmacy.fromJson(Map<String, dynamic> json) =>
      _$OrderPharmacyFromJson(json);
}

@freezed
class Order with _$Order {
  const factory Order({
    required int id,
    @JsonKey(name: 'drug_id') required int drugId,
    required int quantity,
    required String status,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    @JsonKey(name: 'payment_status') required String paymentStatus,
    @JsonKey(name: 'cod_amount') double? codAmount,
    @JsonKey(name: 'delivery_fee') double? deliveryFee,
    @JsonKey(name: 'platform_fee') double? platformFee,
    @JsonKey(name: 'requires_prescription') @Default(false) bool requiresPrescription,
    @JsonKey(name: 'prescription_image') String? prescriptionImage,
    String? notes,
    @JsonKey(name: 'accepted_at') String? acceptedAt,
    @JsonKey(name: 'delivered_at') String? deliveredAt,
    @JsonKey(name: 'created_at') String? createdAt,
    OrderDrug? drug,
    OrderPharmacy? pharmacy,
  }) = _Order;
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

// Human-readable label and step index for tracking stepper.
extension OrderStatusX on String {
  String get label => switch (this) {
        'searching' => 'جارٍ البحث',
        'accepted' => 'تم القبول',
        'preparing' => 'جارٍ التحضير',
        'picked_up' => 'تم الاستلام',
        'on_the_way' => 'في الطريق',
        'delivered' => 'تم التوصيل',
        'cancelled' => 'ملغى',
        'failed' => 'فشل',
        _ => this,
      };

  int get stepIndex => switch (this) {
        'searching' => 0,
        'accepted' => 1,
        'preparing' => 1,
        'picked_up' => 2,
        'on_the_way' => 2,
        'delivered' => 3,
        _ => 0,
      };

  bool get isTerminal =>
      this == 'delivered' || this == 'cancelled' || this == 'failed';
}
