// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pharmacy_user.freezed.dart';
part 'pharmacy_user.g.dart';

double? _parseDouble(dynamic v) =>
    v == null ? null : double.tryParse(v.toString());

@freezed
class Pharmacy with _$Pharmacy {
  const factory Pharmacy({
    required int id,
    required String name,
    String? phone,
    String? address,
    String? city,
    String? district,
    @JsonKey(fromJson: _parseDouble) double? lat,
    @JsonKey(fromJson: _parseDouble) double? lng,
    @JsonKey(name: 'delivery_radius_km') int? deliveryRadiusKm,
    @JsonKey(name: 'has_delivery') @Default(false) bool hasDelivery,
  }) = _Pharmacy;

  factory Pharmacy.fromJson(Map<String, dynamic> json) =>
      _$PharmacyFromJson(json);
}

@freezed
class PharmacyUser with _$PharmacyUser {
  const factory PharmacyUser({
    required int id,
    required String name,
    required String email,
    required String role,
    int? pharmacyId,
    Pharmacy? pharmacy,
  }) = _PharmacyUser;

  factory PharmacyUser.fromJson(Map<String, dynamic> json) =>
      _$PharmacyUserFromJson(json);
}
