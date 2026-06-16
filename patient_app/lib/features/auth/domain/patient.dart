// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient.freezed.dart';
part 'patient.g.dart';

double? _parseDouble(dynamic v) =>
    v == null ? null : double.tryParse(v.toString());

@freezed
class PatientAddress with _$PatientAddress {
  const factory PatientAddress({
    required int id,
    required String label,
    @JsonKey(name: 'address_line') required String addressLine,
    String? city,
    String? district,
    @JsonKey(fromJson: _parseDouble) double? lat,
    @JsonKey(fromJson: _parseDouble) double? lng,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
  }) = _PatientAddress;

  factory PatientAddress.fromJson(Map<String, dynamic> json) =>
      _$PatientAddressFromJson(json);
}

@freezed
class Patient with _$Patient {
  const factory Patient({
    required int id,
    required String name,
    String? email,
    String? phone,
    @Default([]) List<PatientAddress> addresses,
  }) = _Patient;

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
}
