// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drug_result.freezed.dart';
part 'drug_result.g.dart';

double? _parseDouble(dynamic v) =>
    v == null ? null : double.tryParse(v.toString());

@freezed
class DrugResult with _$DrugResult {
  const factory DrugResult({
    required int id,
    @JsonKey(name: 'name_ar') required String nameAr,
    @JsonKey(name: 'name_en') required String nameEn,
    @JsonKey(name: 'scientific_name') String? scientificName,
    String? form,
    String? strength,
    String? unit,
    @JsonKey(name: 'official_price_egp', fromJson: _parseDouble) double? officialPriceEgp,
    @JsonKey(name: 'requires_prescription') @Default(false) bool requiresPrescription,
    @Default(false) bool available,
  }) = _DrugResult;

  factory DrugResult.fromJson(Map<String, dynamic> json) =>
      _$DrugResultFromJson(json);
}
