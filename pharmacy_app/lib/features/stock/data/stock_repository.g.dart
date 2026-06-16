// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DrugLookupResultImpl _$$DrugLookupResultImplFromJson(
        Map<String, dynamic> json) =>
    _$DrugLookupResultImpl(
      drugId: (json['drugId'] as num).toInt(),
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String?,
      form: json['form'] as String?,
      strength: json['strength'] as String?,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$DrugLookupResultImplToJson(
        _$DrugLookupResultImpl instance) =>
    <String, dynamic>{
      'drugId': instance.drugId,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'form': instance.form,
      'strength': instance.strength,
      'quantity': instance.quantity,
    };
