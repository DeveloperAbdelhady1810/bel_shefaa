// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pharmacy_user.freezed.dart';
part 'pharmacy_user.g.dart';

double? _parseDouble(dynamic v) =>
    v == null ? null : double.tryParse(v.toString());

int _parseInt(dynamic v) =>
    v == null ? 0 : int.tryParse(v.toString()) ?? 0;

int? _parseIntNullable(dynamic v) =>
    v == null ? null : int.tryParse(v.toString());

@freezed
class Pharmacy with _$Pharmacy {
  const factory Pharmacy({
    @JsonKey(fromJson: _parseInt) required int id,
    required String name,
    String? phone,
    String? address,
    String? city,
    String? district,
    @JsonKey(fromJson: _parseDouble) double? lat,
    @JsonKey(fromJson: _parseDouble) double? lng,
    @JsonKey(name: 'delivery_radius_km', fromJson: _parseIntNullable)
    int? deliveryRadiusKm,
    @JsonKey(name: 'has_delivery') @Default(false) bool hasDelivery,
  }) = _Pharmacy;

  factory Pharmacy.fromJson(Map<String, dynamic> json) =>
      _$PharmacyFromJson(json);
}

@freezed
class PharmacyUser with _$PharmacyUser {
  const factory PharmacyUser({
    @JsonKey(fromJson: _parseInt) required int id,
    required String name,
    required String email,
    required String role,
    @JsonKey(name: 'pharmacy_id', fromJson: _parseIntNullable) int? pharmacyId,
    Pharmacy? pharmacy,
  }) = _PharmacyUser;

  factory PharmacyUser.fromJson(Map<String, dynamic> json) =>
      _$PharmacyUserFromJson(json);
}
