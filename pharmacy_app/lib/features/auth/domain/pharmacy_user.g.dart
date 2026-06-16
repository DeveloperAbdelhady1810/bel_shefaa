// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PharmacyImpl _$$PharmacyImplFromJson(Map<String, dynamic> json) =>
    _$PharmacyImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$$PharmacyImplToJson(_$PharmacyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
    };

_$PharmacyUserImpl _$$PharmacyUserImplFromJson(Map<String, dynamic> json) =>
    _$PharmacyUserImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      pharmacyId: (json['pharmacyId'] as num?)?.toInt(),
      pharmacy: json['pharmacy'] == null
          ? null
          : Pharmacy.fromJson(json['pharmacy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PharmacyUserImplToJson(_$PharmacyUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'pharmacyId': instance.pharmacyId,
      'pharmacy': instance.pharmacy,
    };
