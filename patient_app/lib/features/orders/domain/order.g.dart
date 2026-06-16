// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderDrugImpl _$$OrderDrugImplFromJson(Map<String, dynamic> json) =>
    _$OrderDrugImpl(
      id: (json['id'] as num).toInt(),
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String?,
      form: json['form'] as String?,
      strength: json['strength'] as String?,
    );

Map<String, dynamic> _$$OrderDrugImplToJson(_$OrderDrugImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_ar': instance.nameAr,
      'name_en': instance.nameEn,
      'form': instance.form,
      'strength': instance.strength,
    };

_$OrderPharmacyImpl _$$OrderPharmacyImplFromJson(Map<String, dynamic> json) =>
    _$OrderPharmacyImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$$OrderPharmacyImplToJson(_$OrderPharmacyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
    };

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: (json['id'] as num).toInt(),
      drugId: (json['drug_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String,
      paymentStatus: json['payment_status'] as String,
      codAmount: (json['cod_amount'] as num?)?.toDouble(),
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble(),
      platformFee: (json['platform_fee'] as num?)?.toDouble(),
      requiresPrescription: json['requires_prescription'] as bool? ?? false,
      prescriptionImage: json['prescription_image'] as String?,
      notes: json['notes'] as String?,
      acceptedAt: json['accepted_at'] as String?,
      deliveredAt: json['delivered_at'] as String?,
      createdAt: json['created_at'] as String?,
      drug: json['drug'] == null
          ? null
          : OrderDrug.fromJson(json['drug'] as Map<String, dynamic>),
      pharmacy: json['pharmacy'] == null
          ? null
          : OrderPharmacy.fromJson(json['pharmacy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'drug_id': instance.drugId,
      'quantity': instance.quantity,
      'status': instance.status,
      'payment_method': instance.paymentMethod,
      'payment_status': instance.paymentStatus,
      'cod_amount': instance.codAmount,
      'delivery_fee': instance.deliveryFee,
      'platform_fee': instance.platformFee,
      'requires_prescription': instance.requiresPrescription,
      'prescription_image': instance.prescriptionImage,
      'notes': instance.notes,
      'accepted_at': instance.acceptedAt,
      'delivered_at': instance.deliveredAt,
      'created_at': instance.createdAt,
      'drug': instance.drug,
      'pharmacy': instance.pharmacy,
    };
