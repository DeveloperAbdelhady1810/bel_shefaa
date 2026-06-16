// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DrugResultImpl _$$DrugResultImplFromJson(Map<String, dynamic> json) =>
    _$DrugResultImpl(
      id: (json['id'] as num).toInt(),
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      scientificName: json['scientific_name'] as String?,
      form: json['form'] as String?,
      strength: json['strength'] as String?,
      unit: json['unit'] as String?,
      officialPriceEgp: (json['official_price_egp'] as num?)?.toDouble(),
      requiresPrescription: json['requires_prescription'] as bool? ?? false,
      available: json['available'] as bool? ?? false,
    );

Map<String, dynamic> _$$DrugResultImplToJson(_$DrugResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_ar': instance.nameAr,
      'name_en': instance.nameEn,
      'scientific_name': instance.scientificName,
      'form': instance.form,
      'strength': instance.strength,
      'unit': instance.unit,
      'official_price_egp': instance.officialPriceEgp,
      'requires_prescription': instance.requiresPrescription,
      'available': instance.available,
    };
