// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderDrug _$OrderDrugFromJson(Map<String, dynamic> json) {
  return _OrderDrug.fromJson(json);
}

/// @nodoc
mixin _$OrderDrug {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_ar')
  String get nameAr => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_en')
  String? get nameEn => throw _privateConstructorUsedError;
  String? get form => throw _privateConstructorUsedError;
  String? get strength => throw _privateConstructorUsedError;

  /// Serializes this OrderDrug to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderDrug
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDrugCopyWith<OrderDrug> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDrugCopyWith<$Res> {
  factory $OrderDrugCopyWith(OrderDrug value, $Res Function(OrderDrug) then) =
      _$OrderDrugCopyWithImpl<$Res, OrderDrug>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'name_ar') String nameAr,
      @JsonKey(name: 'name_en') String? nameEn,
      String? form,
      String? strength});
}

/// @nodoc
class _$OrderDrugCopyWithImpl<$Res, $Val extends OrderDrug>
    implements $OrderDrugCopyWith<$Res> {
  _$OrderDrugCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDrug
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = freezed,
    Object? form = freezed,
    Object? strength = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: freezed == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String?,
      form: freezed == form
          ? _value.form
          : form // ignore: cast_nullable_to_non_nullable
              as String?,
      strength: freezed == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderDrugImplCopyWith<$Res>
    implements $OrderDrugCopyWith<$Res> {
  factory _$$OrderDrugImplCopyWith(
          _$OrderDrugImpl value, $Res Function(_$OrderDrugImpl) then) =
      __$$OrderDrugImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'name_ar') String nameAr,
      @JsonKey(name: 'name_en') String? nameEn,
      String? form,
      String? strength});
}

/// @nodoc
class __$$OrderDrugImplCopyWithImpl<$Res>
    extends _$OrderDrugCopyWithImpl<$Res, _$OrderDrugImpl>
    implements _$$OrderDrugImplCopyWith<$Res> {
  __$$OrderDrugImplCopyWithImpl(
      _$OrderDrugImpl _value, $Res Function(_$OrderDrugImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderDrug
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = freezed,
    Object? form = freezed,
    Object? strength = freezed,
  }) {
    return _then(_$OrderDrugImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: freezed == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String?,
      form: freezed == form
          ? _value.form
          : form // ignore: cast_nullable_to_non_nullable
              as String?,
      strength: freezed == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderDrugImpl implements _OrderDrug {
  const _$OrderDrugImpl(
      {required this.id,
      @JsonKey(name: 'name_ar') required this.nameAr,
      @JsonKey(name: 'name_en') this.nameEn,
      this.form,
      this.strength});

  factory _$OrderDrugImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderDrugImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'name_ar')
  final String nameAr;
  @override
  @JsonKey(name: 'name_en')
  final String? nameEn;
  @override
  final String? form;
  @override
  final String? strength;

  @override
  String toString() {
    return 'OrderDrug(id: $id, nameAr: $nameAr, nameEn: $nameEn, form: $form, strength: $strength)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDrugImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.strength, strength) ||
                other.strength == strength));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nameAr, nameEn, form, strength);

  /// Create a copy of OrderDrug
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDrugImplCopyWith<_$OrderDrugImpl> get copyWith =>
      __$$OrderDrugImplCopyWithImpl<_$OrderDrugImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderDrugImplToJson(
      this,
    );
  }
}

abstract class _OrderDrug implements OrderDrug {
  const factory _OrderDrug(
      {required final int id,
      @JsonKey(name: 'name_ar') required final String nameAr,
      @JsonKey(name: 'name_en') final String? nameEn,
      final String? form,
      final String? strength}) = _$OrderDrugImpl;

  factory _OrderDrug.fromJson(Map<String, dynamic> json) =
      _$OrderDrugImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'name_ar')
  String get nameAr;
  @override
  @JsonKey(name: 'name_en')
  String? get nameEn;
  @override
  String? get form;
  @override
  String? get strength;

  /// Create a copy of OrderDrug
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDrugImplCopyWith<_$OrderDrugImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderPharmacy _$OrderPharmacyFromJson(Map<String, dynamic> json) {
  return _OrderPharmacy.fromJson(json);
}

/// @nodoc
mixin _$OrderPharmacy {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  /// Serializes this OrderPharmacy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderPharmacy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderPharmacyCopyWith<OrderPharmacy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderPharmacyCopyWith<$Res> {
  factory $OrderPharmacyCopyWith(
          OrderPharmacy value, $Res Function(OrderPharmacy) then) =
      _$OrderPharmacyCopyWithImpl<$Res, OrderPharmacy>;
  @useResult
  $Res call({int id, String name, String? phone, String? address});
}

/// @nodoc
class _$OrderPharmacyCopyWithImpl<$Res, $Val extends OrderPharmacy>
    implements $OrderPharmacyCopyWith<$Res> {
  _$OrderPharmacyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderPharmacy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = freezed,
    Object? address = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderPharmacyImplCopyWith<$Res>
    implements $OrderPharmacyCopyWith<$Res> {
  factory _$$OrderPharmacyImplCopyWith(
          _$OrderPharmacyImpl value, $Res Function(_$OrderPharmacyImpl) then) =
      __$$OrderPharmacyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String? phone, String? address});
}

/// @nodoc
class __$$OrderPharmacyImplCopyWithImpl<$Res>
    extends _$OrderPharmacyCopyWithImpl<$Res, _$OrderPharmacyImpl>
    implements _$$OrderPharmacyImplCopyWith<$Res> {
  __$$OrderPharmacyImplCopyWithImpl(
      _$OrderPharmacyImpl _value, $Res Function(_$OrderPharmacyImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderPharmacy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = freezed,
    Object? address = freezed,
  }) {
    return _then(_$OrderPharmacyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderPharmacyImpl implements _OrderPharmacy {
  const _$OrderPharmacyImpl(
      {required this.id, required this.name, this.phone, this.address});

  factory _$OrderPharmacyImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderPharmacyImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? address;

  @override
  String toString() {
    return 'OrderPharmacy(id: $id, name: $name, phone: $phone, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderPharmacyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, phone, address);

  /// Create a copy of OrderPharmacy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderPharmacyImplCopyWith<_$OrderPharmacyImpl> get copyWith =>
      __$$OrderPharmacyImplCopyWithImpl<_$OrderPharmacyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderPharmacyImplToJson(
      this,
    );
  }
}

abstract class _OrderPharmacy implements OrderPharmacy {
  const factory _OrderPharmacy(
      {required final int id,
      required final String name,
      final String? phone,
      final String? address}) = _$OrderPharmacyImpl;

  factory _OrderPharmacy.fromJson(Map<String, dynamic> json) =
      _$OrderPharmacyImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get address;

  /// Create a copy of OrderPharmacy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderPharmacyImplCopyWith<_$OrderPharmacyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'drug_id')
  int get drugId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'cod_amount')
  double? get codAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_fee')
  double? get deliveryFee => throw _privateConstructorUsedError;
  @JsonKey(name: 'platform_fee')
  double? get platformFee => throw _privateConstructorUsedError;
  @JsonKey(name: 'requires_prescription')
  bool get requiresPrescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'prescription_image')
  String? get prescriptionImage => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'accepted_at')
  String? get acceptedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivered_at')
  String? get deliveredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  OrderDrug? get drug => throw _privateConstructorUsedError;
  OrderPharmacy? get pharmacy => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'drug_id') int drugId,
      int quantity,
      String status,
      @JsonKey(name: 'payment_method') String paymentMethod,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'cod_amount') double? codAmount,
      @JsonKey(name: 'delivery_fee') double? deliveryFee,
      @JsonKey(name: 'platform_fee') double? platformFee,
      @JsonKey(name: 'requires_prescription') bool requiresPrescription,
      @JsonKey(name: 'prescription_image') String? prescriptionImage,
      String? notes,
      @JsonKey(name: 'accepted_at') String? acceptedAt,
      @JsonKey(name: 'delivered_at') String? deliveredAt,
      @JsonKey(name: 'created_at') String? createdAt,
      OrderDrug? drug,
      OrderPharmacy? pharmacy});

  $OrderDrugCopyWith<$Res>? get drug;
  $OrderPharmacyCopyWith<$Res>? get pharmacy;
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? drugId = null,
    Object? quantity = null,
    Object? status = null,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
    Object? codAmount = freezed,
    Object? deliveryFee = freezed,
    Object? platformFee = freezed,
    Object? requiresPrescription = null,
    Object? prescriptionImage = freezed,
    Object? notes = freezed,
    Object? acceptedAt = freezed,
    Object? deliveredAt = freezed,
    Object? createdAt = freezed,
    Object? drug = freezed,
    Object? pharmacy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      drugId: null == drugId
          ? _value.drugId
          : drugId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      codAmount: freezed == codAmount
          ? _value.codAmount
          : codAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      deliveryFee: freezed == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double?,
      platformFee: freezed == platformFee
          ? _value.platformFee
          : platformFee // ignore: cast_nullable_to_non_nullable
              as double?,
      requiresPrescription: null == requiresPrescription
          ? _value.requiresPrescription
          : requiresPrescription // ignore: cast_nullable_to_non_nullable
              as bool,
      prescriptionImage: freezed == prescriptionImage
          ? _value.prescriptionImage
          : prescriptionImage // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      drug: freezed == drug
          ? _value.drug
          : drug // ignore: cast_nullable_to_non_nullable
              as OrderDrug?,
      pharmacy: freezed == pharmacy
          ? _value.pharmacy
          : pharmacy // ignore: cast_nullable_to_non_nullable
              as OrderPharmacy?,
    ) as $Val);
  }

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderDrugCopyWith<$Res>? get drug {
    if (_value.drug == null) {
      return null;
    }

    return $OrderDrugCopyWith<$Res>(_value.drug!, (value) {
      return _then(_value.copyWith(drug: value) as $Val);
    });
  }

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderPharmacyCopyWith<$Res>? get pharmacy {
    if (_value.pharmacy == null) {
      return null;
    }

    return $OrderPharmacyCopyWith<$Res>(_value.pharmacy!, (value) {
      return _then(_value.copyWith(pharmacy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
          _$OrderImpl value, $Res Function(_$OrderImpl) then) =
      __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'drug_id') int drugId,
      int quantity,
      String status,
      @JsonKey(name: 'payment_method') String paymentMethod,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'cod_amount') double? codAmount,
      @JsonKey(name: 'delivery_fee') double? deliveryFee,
      @JsonKey(name: 'platform_fee') double? platformFee,
      @JsonKey(name: 'requires_prescription') bool requiresPrescription,
      @JsonKey(name: 'prescription_image') String? prescriptionImage,
      String? notes,
      @JsonKey(name: 'accepted_at') String? acceptedAt,
      @JsonKey(name: 'delivered_at') String? deliveredAt,
      @JsonKey(name: 'created_at') String? createdAt,
      OrderDrug? drug,
      OrderPharmacy? pharmacy});

  @override
  $OrderDrugCopyWith<$Res>? get drug;
  @override
  $OrderPharmacyCopyWith<$Res>? get pharmacy;
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
      _$OrderImpl _value, $Res Function(_$OrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? drugId = null,
    Object? quantity = null,
    Object? status = null,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
    Object? codAmount = freezed,
    Object? deliveryFee = freezed,
    Object? platformFee = freezed,
    Object? requiresPrescription = null,
    Object? prescriptionImage = freezed,
    Object? notes = freezed,
    Object? acceptedAt = freezed,
    Object? deliveredAt = freezed,
    Object? createdAt = freezed,
    Object? drug = freezed,
    Object? pharmacy = freezed,
  }) {
    return _then(_$OrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      drugId: null == drugId
          ? _value.drugId
          : drugId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      codAmount: freezed == codAmount
          ? _value.codAmount
          : codAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      deliveryFee: freezed == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double?,
      platformFee: freezed == platformFee
          ? _value.platformFee
          : platformFee // ignore: cast_nullable_to_non_nullable
              as double?,
      requiresPrescription: null == requiresPrescription
          ? _value.requiresPrescription
          : requiresPrescription // ignore: cast_nullable_to_non_nullable
              as bool,
      prescriptionImage: freezed == prescriptionImage
          ? _value.prescriptionImage
          : prescriptionImage // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      drug: freezed == drug
          ? _value.drug
          : drug // ignore: cast_nullable_to_non_nullable
              as OrderDrug?,
      pharmacy: freezed == pharmacy
          ? _value.pharmacy
          : pharmacy // ignore: cast_nullable_to_non_nullable
              as OrderPharmacy?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl(
      {required this.id,
      @JsonKey(name: 'drug_id') required this.drugId,
      required this.quantity,
      required this.status,
      @JsonKey(name: 'payment_method') required this.paymentMethod,
      @JsonKey(name: 'payment_status') required this.paymentStatus,
      @JsonKey(name: 'cod_amount') this.codAmount,
      @JsonKey(name: 'delivery_fee') this.deliveryFee,
      @JsonKey(name: 'platform_fee') this.platformFee,
      @JsonKey(name: 'requires_prescription') this.requiresPrescription = false,
      @JsonKey(name: 'prescription_image') this.prescriptionImage,
      this.notes,
      @JsonKey(name: 'accepted_at') this.acceptedAt,
      @JsonKey(name: 'delivered_at') this.deliveredAt,
      @JsonKey(name: 'created_at') this.createdAt,
      this.drug,
      this.pharmacy});

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'drug_id')
  final int drugId;
  @override
  final int quantity;
  @override
  final String status;
  @override
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @override
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @override
  @JsonKey(name: 'cod_amount')
  final double? codAmount;
  @override
  @JsonKey(name: 'delivery_fee')
  final double? deliveryFee;
  @override
  @JsonKey(name: 'platform_fee')
  final double? platformFee;
  @override
  @JsonKey(name: 'requires_prescription')
  final bool requiresPrescription;
  @override
  @JsonKey(name: 'prescription_image')
  final String? prescriptionImage;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'accepted_at')
  final String? acceptedAt;
  @override
  @JsonKey(name: 'delivered_at')
  final String? deliveredAt;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  final OrderDrug? drug;
  @override
  final OrderPharmacy? pharmacy;

  @override
  String toString() {
    return 'Order(id: $id, drugId: $drugId, quantity: $quantity, status: $status, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, codAmount: $codAmount, deliveryFee: $deliveryFee, platformFee: $platformFee, requiresPrescription: $requiresPrescription, prescriptionImage: $prescriptionImage, notes: $notes, acceptedAt: $acceptedAt, deliveredAt: $deliveredAt, createdAt: $createdAt, drug: $drug, pharmacy: $pharmacy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.drugId, drugId) || other.drugId == drugId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.codAmount, codAmount) ||
                other.codAmount == codAmount) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.platformFee, platformFee) ||
                other.platformFee == platformFee) &&
            (identical(other.requiresPrescription, requiresPrescription) ||
                other.requiresPrescription == requiresPrescription) &&
            (identical(other.prescriptionImage, prescriptionImage) ||
                other.prescriptionImage == prescriptionImage) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.drug, drug) || other.drug == drug) &&
            (identical(other.pharmacy, pharmacy) ||
                other.pharmacy == pharmacy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      drugId,
      quantity,
      status,
      paymentMethod,
      paymentStatus,
      codAmount,
      deliveryFee,
      platformFee,
      requiresPrescription,
      prescriptionImage,
      notes,
      acceptedAt,
      deliveredAt,
      createdAt,
      drug,
      pharmacy);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(
      this,
    );
  }
}

abstract class _Order implements Order {
  const factory _Order(
      {required final int id,
      @JsonKey(name: 'drug_id') required final int drugId,
      required final int quantity,
      required final String status,
      @JsonKey(name: 'payment_method') required final String paymentMethod,
      @JsonKey(name: 'payment_status') required final String paymentStatus,
      @JsonKey(name: 'cod_amount') final double? codAmount,
      @JsonKey(name: 'delivery_fee') final double? deliveryFee,
      @JsonKey(name: 'platform_fee') final double? platformFee,
      @JsonKey(name: 'requires_prescription') final bool requiresPrescription,
      @JsonKey(name: 'prescription_image') final String? prescriptionImage,
      final String? notes,
      @JsonKey(name: 'accepted_at') final String? acceptedAt,
      @JsonKey(name: 'delivered_at') final String? deliveredAt,
      @JsonKey(name: 'created_at') final String? createdAt,
      final OrderDrug? drug,
      final OrderPharmacy? pharmacy}) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'drug_id')
  int get drugId;
  @override
  int get quantity;
  @override
  String get status;
  @override
  @JsonKey(name: 'payment_method')
  String get paymentMethod;
  @override
  @JsonKey(name: 'payment_status')
  String get paymentStatus;
  @override
  @JsonKey(name: 'cod_amount')
  double? get codAmount;
  @override
  @JsonKey(name: 'delivery_fee')
  double? get deliveryFee;
  @override
  @JsonKey(name: 'platform_fee')
  double? get platformFee;
  @override
  @JsonKey(name: 'requires_prescription')
  bool get requiresPrescription;
  @override
  @JsonKey(name: 'prescription_image')
  String? get prescriptionImage;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'accepted_at')
  String? get acceptedAt;
  @override
  @JsonKey(name: 'delivered_at')
  String? get deliveredAt;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  OrderDrug? get drug;
  @override
  OrderPharmacy? get pharmacy;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
