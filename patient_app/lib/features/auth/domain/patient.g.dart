// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientAddressImpl _$$PatientAddressImplFromJson(Map<String, dynamic> json) =>
    _$PatientAddressImpl(
      id: (json['id'] as num).toInt(),
      label: json['label'] as String,
      addressLine: json['address_line'] as String,
      city: json['city'] as String?,
      district: json['district'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      isDefault: json['is_default'] as bool? ?? false,
    );

Map<String, dynamic> _$$PatientAddressImplToJson(
        _$PatientAddressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'address_line': instance.addressLine,
      'city': instance.city,
      'district': instance.district,
      'lat': instance.lat,
      'lng': instance.lng,
      'is_default': instance.isDefault,
    };

_$PatientImpl _$$PatientImplFromJson(Map<String, dynamic> json) =>
    _$PatientImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => PatientAddress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PatientImplToJson(_$PatientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'addresses': instance.addresses,
    };
