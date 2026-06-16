import 'package:freezed_annotation/freezed_annotation.dart';

part 'pharmacy_user.freezed.dart';
part 'pharmacy_user.g.dart';

@freezed
class Pharmacy with _$Pharmacy {
  const factory Pharmacy({
    required int id,
    required String name,
    String? phone,
    String? address,
    String? city,
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
