// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IncomingDrugImpl _$$IncomingDrugImplFromJson(Map<String, dynamic> json) =>
    _$IncomingDrugImpl(
      id: _parseInt(json['id']),
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      form: json['form'] as String?,
      strength: json['strength'] as String?,
      unit: json['unit'] as String?,
      requiresPrescription: json['requires_prescription'] as bool? ?? false,
    );

Map<String, dynamic> _$$IncomingDrugImplToJson(_$IncomingDrugImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_ar': instance.nameAr,
      'name_en': instance.nameEn,
      'form': instance.form,
      'strength': instance.strength,
      'unit': instance.unit,
      'requires_prescription': instance.requiresPrescription,
    };

_$IncomingAddressImpl _$$IncomingAddressImplFromJson(
        Map<String, dynamic> json) =>
    _$IncomingAddressImpl(
      id: _parseInt(json['id']),
      addressLine: json['address_line'] as String,
      city: json['city'] as String?,
      district: json['district'] as String?,
      lat: _parseDouble(json['lat']),
      lng: _parseDouble(json['lng']),
    );

Map<String, dynamic> _$$IncomingAddressImplToJson(
        _$IncomingAddressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address_line': instance.addressLine,
      'city': instance.city,
      'district': instance.district,
      'lat': instance.lat,
      'lng': instance.lng,
    };

_$IncomingPatientImpl _$$IncomingPatientImplFromJson(
        Map<String, dynamic> json) =>
    _$IncomingPatientImpl(
      id: _parseInt(json['id']),
      name: json['name'] as String,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$IncomingPatientImplToJson(
        _$IncomingPatientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
    };

_$IncomingOrderDetailImpl _$$IncomingOrderDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$IncomingOrderDetailImpl(
      id: _parseInt(json['id']),
      drugId: _parseInt(json['drug_id']),
      quantity: _parseInt(json['quantity']),
      notes: json['notes'] as String?,
      prescriptionImage: json['prescription_image'] as String?,
      requiresPrescription: json['requires_prescription'] as bool? ?? false,
      codAmount: _parseDouble(json['cod_amount']),
      deliveryFee: _parseDouble(json['delivery_fee']),
      paymentMethod: json['payment_method'] as String?,
      drug: json['drug'] == null
          ? null
          : IncomingDrug.fromJson(json['drug'] as Map<String, dynamic>),
      patientAddress: json['patient_address'] == null
          ? null
          : IncomingAddress.fromJson(
              json['patient_address'] as Map<String, dynamic>),
      patient: json['patient'] == null
          ? null
          : IncomingPatient.fromJson(json['patient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$IncomingOrderDetailImplToJson(
        _$IncomingOrderDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'drug_id': instance.drugId,
      'quantity': instance.quantity,
      'notes': instance.notes,
      'prescription_image': instance.prescriptionImage,
      'requires_prescription': instance.requiresPrescription,
      'cod_amount': instance.codAmount,
      'delivery_fee': instance.deliveryFee,
      'payment_method': instance.paymentMethod,
      'drug': instance.drug,
      'patient_address': instance.patientAddress,
      'patient': instance.patient,
    };

_$IncomingOrderImpl _$$IncomingOrderImplFromJson(Map<String, dynamic> json) =>
    _$IncomingOrderImpl(
      id: _parseInt(json['id']),
      orderId: _parseInt(json['order_id']),
      pharmacyId: _parseInt(json['pharmacy_id']),
      status: json['status'] as String,
      sentAt: json['sent_at'] as String?,
      expiresAt: json['expires_at'] as String?,
      order: json['order'] == null
          ? null
          : IncomingOrderDetail.fromJson(json['order'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$IncomingOrderImplToJson(_$IncomingOrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'pharmacy_id': instance.pharmacyId,
      'status': instance.status,
      'sent_at': instance.sentAt,
      'expires_at': instance.expiresAt,
      'order': instance.order,
    };
