// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PharmacyImpl _$$PharmacyImplFromJson(Map<String, dynamic> json) =>
    _$PharmacyImpl(
      id: _parseInt(json['id']),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      lat: _parseDouble(json['lat']),
      lng: _parseDouble(json['lng']),
      deliveryRadiusKm: _parseIntNullable(json['delivery_radius_km']),
      hasDelivery: json['has_delivery'] as bool? ?? false,
    );

Map<String, dynamic> _$$PharmacyImplToJson(_$PharmacyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
      'district': instance.district,
      'lat': instance.lat,
      'lng': instance.lng,
      'delivery_radius_km': instance.deliveryRadiusKm,
      'has_delivery': instance.hasDelivery,
    };

_$PharmacyUserImpl _$$PharmacyUserImplFromJson(Map<String, dynamic> json) =>
    _$PharmacyUserImpl(
      id: _parseInt(json['id']),
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      pharmacyId: _parseIntNullable(json['pharmacy_id']),
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
      'pharmacy_id': instance.pharmacyId,
      'pharmacy': instance.pharmacy,
    };
