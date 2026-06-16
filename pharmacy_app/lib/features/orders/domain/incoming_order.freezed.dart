// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incoming_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IncomingDrug _$IncomingDrugFromJson(Map<String, dynamic> json) {
  return _IncomingDrug.fromJson(json);
}

/// @nodoc
mixin _$IncomingDrug {
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_ar')
  String get nameAr => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_en')
  String get nameEn => throw _privateConstructorUsedError;
  String? get form => throw _privateConstructorUsedError;
  String? get strength => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'requires_prescription')
  bool get requiresPrescription => throw _privateConstructorUsedError;

  /// Serializes this IncomingDrug to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IncomingDrug
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomingDrugCopyWith<IncomingDrug> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomingDrugCopyWith<$Res> {
  factory $IncomingDrugCopyWith(
          IncomingDrug value, $Res Function(IncomingDrug) then) =
      _$IncomingDrugCopyWithImpl<$Res, IncomingDrug>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(name: 'name_ar') String nameAr,
      @JsonKey(name: 'name_en') String nameEn,
      String? form,
      String? strength,
      String? unit,
      @JsonKey(name: 'requires_prescription') bool requiresPrescription});
}

/// @nodoc
class _$IncomingDrugCopyWithImpl<$Res, $Val extends IncomingDrug>
    implements $IncomingDrugCopyWith<$Res> {
  _$IncomingDrugCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomingDrug
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? form = freezed,
    Object? strength = freezed,
    Object? unit = freezed,
    Object? requiresPrescription = null,
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
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      form: freezed == form
          ? _value.form
          : form // ignore: cast_nullable_to_non_nullable
              as String?,
      strength: freezed == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresPrescription: null == requiresPrescription
          ? _value.requiresPrescription
          : requiresPrescription // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomingDrugImplCopyWith<$Res>
    implements $IncomingDrugCopyWith<$Res> {
  factory _$$IncomingDrugImplCopyWith(
          _$IncomingDrugImpl value, $Res Function(_$IncomingDrugImpl) then) =
      __$$IncomingDrugImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(name: 'name_ar') String nameAr,
      @JsonKey(name: 'name_en') String nameEn,
      String? form,
      String? strength,
      String? unit,
      @JsonKey(name: 'requires_prescription') bool requiresPrescription});
}

/// @nodoc
class __$$IncomingDrugImplCopyWithImpl<$Res>
    extends _$IncomingDrugCopyWithImpl<$Res, _$IncomingDrugImpl>
    implements _$$IncomingDrugImplCopyWith<$Res> {
  __$$IncomingDrugImplCopyWithImpl(
      _$IncomingDrugImpl _value, $Res Function(_$IncomingDrugImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncomingDrug
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? form = freezed,
    Object? strength = freezed,
    Object? unit = freezed,
    Object? requiresPrescription = null,
  }) {
    return _then(_$IncomingDrugImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      form: freezed == form
          ? _value.form
          : form // ignore: cast_nullable_to_non_nullable
              as String?,
      strength: freezed == strength
          ? _value.strength
          : strength // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresPrescription: null == requiresPrescription
          ? _value.requiresPrescription
          : requiresPrescription // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncomingDrugImpl implements _IncomingDrug {
  const _$IncomingDrugImpl(
      {@JsonKey(fromJson: _parseInt) required this.id,
      @JsonKey(name: 'name_ar') required this.nameAr,
      @JsonKey(name: 'name_en') required this.nameEn,
      this.form,
      this.strength,
      this.unit,
      @JsonKey(name: 'requires_prescription')
      this.requiresPrescription = false});

  factory _$IncomingDrugImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncomingDrugImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  @JsonKey(name: 'name_ar')
  final String nameAr;
  @override
  @JsonKey(name: 'name_en')
  final String nameEn;
  @override
  final String? form;
  @override
  final String? strength;
  @override
  final String? unit;
  @override
  @JsonKey(name: 'requires_prescription')
  final bool requiresPrescription;

  @override
  String toString() {
    return 'IncomingDrug(id: $id, nameAr: $nameAr, nameEn: $nameEn, form: $form, strength: $strength, unit: $unit, requiresPrescription: $requiresPrescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingDrugImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.strength, strength) ||
                other.strength == strength) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.requiresPrescription, requiresPrescription) ||
                other.requiresPrescription == requiresPrescription));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameAr, nameEn, form,
      strength, unit, requiresPrescription);

  /// Create a copy of IncomingDrug
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomingDrugImplCopyWith<_$IncomingDrugImpl> get copyWith =>
      __$$IncomingDrugImplCopyWithImpl<_$IncomingDrugImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncomingDrugImplToJson(
      this,
    );
  }
}

abstract class _IncomingDrug implements IncomingDrug {
  const factory _IncomingDrug(
      {@JsonKey(fromJson: _parseInt) required final int id,
      @JsonKey(name: 'name_ar') required final String nameAr,
      @JsonKey(name: 'name_en') required final String nameEn,
      final String? form,
      final String? strength,
      final String? unit,
      @JsonKey(name: 'requires_prescription')
      final bool requiresPrescription}) = _$IncomingDrugImpl;

  factory _IncomingDrug.fromJson(Map<String, dynamic> json) =
      _$IncomingDrugImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  @JsonKey(name: 'name_ar')
  String get nameAr;
  @override
  @JsonKey(name: 'name_en')
  String get nameEn;
  @override
  String? get form;
  @override
  String? get strength;
  @override
  String? get unit;
  @override
  @JsonKey(name: 'requires_prescription')
  bool get requiresPrescription;

  /// Create a copy of IncomingDrug
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomingDrugImplCopyWith<_$IncomingDrugImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IncomingAddress _$IncomingAddressFromJson(Map<String, dynamic> json) {
  return _IncomingAddress.fromJson(json);
}

/// @nodoc
mixin _$IncomingAddress {
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line')
  String get addressLine => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get district => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get lat => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get lng => throw _privateConstructorUsedError;

  /// Serializes this IncomingAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IncomingAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomingAddressCopyWith<IncomingAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomingAddressCopyWith<$Res> {
  factory $IncomingAddressCopyWith(
          IncomingAddress value, $Res Function(IncomingAddress) then) =
      _$IncomingAddressCopyWithImpl<$Res, IncomingAddress>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(name: 'address_line') String addressLine,
      String? city,
      String? district,
      @JsonKey(fromJson: _parseDouble) double? lat,
      @JsonKey(fromJson: _parseDouble) double? lng});
}

/// @nodoc
class _$IncomingAddressCopyWithImpl<$Res, $Val extends IncomingAddress>
    implements $IncomingAddressCopyWith<$Res> {
  _$IncomingAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomingAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? addressLine = null,
    Object? city = freezed,
    Object? district = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      addressLine: null == addressLine
          ? _value.addressLine
          : addressLine // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      district: freezed == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomingAddressImplCopyWith<$Res>
    implements $IncomingAddressCopyWith<$Res> {
  factory _$$IncomingAddressImplCopyWith(_$IncomingAddressImpl value,
          $Res Function(_$IncomingAddressImpl) then) =
      __$$IncomingAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(name: 'address_line') String addressLine,
      String? city,
      String? district,
      @JsonKey(fromJson: _parseDouble) double? lat,
      @JsonKey(fromJson: _parseDouble) double? lng});
}

/// @nodoc
class __$$IncomingAddressImplCopyWithImpl<$Res>
    extends _$IncomingAddressCopyWithImpl<$Res, _$IncomingAddressImpl>
    implements _$$IncomingAddressImplCopyWith<$Res> {
  __$$IncomingAddressImplCopyWithImpl(
      _$IncomingAddressImpl _value, $Res Function(_$IncomingAddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncomingAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? addressLine = null,
    Object? city = freezed,
    Object? district = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(_$IncomingAddressImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      addressLine: null == addressLine
          ? _value.addressLine
          : addressLine // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      district: freezed == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncomingAddressImpl implements _IncomingAddress {
  const _$IncomingAddressImpl(
      {@JsonKey(fromJson: _parseInt) required this.id,
      @JsonKey(name: 'address_line') required this.addressLine,
      this.city,
      this.district,
      @JsonKey(fromJson: _parseDouble) this.lat,
      @JsonKey(fromJson: _parseDouble) this.lng});

  factory _$IncomingAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncomingAddressImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  @JsonKey(name: 'address_line')
  final String addressLine;
  @override
  final String? city;
  @override
  final String? district;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? lat;
  @override
  @JsonKey(fromJson: _parseDouble)
  final double? lng;

  @override
  String toString() {
    return 'IncomingAddress(id: $id, addressLine: $addressLine, city: $city, district: $district, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingAddressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.addressLine, addressLine) ||
                other.addressLine == addressLine) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, addressLine, city, district, lat, lng);

  /// Create a copy of IncomingAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomingAddressImplCopyWith<_$IncomingAddressImpl> get copyWith =>
      __$$IncomingAddressImplCopyWithImpl<_$IncomingAddressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncomingAddressImplToJson(
      this,
    );
  }
}

abstract class _IncomingAddress implements IncomingAddress {
  const factory _IncomingAddress(
          {@JsonKey(fromJson: _parseInt) required final int id,
          @JsonKey(name: 'address_line') required final String addressLine,
          final String? city,
          final String? district,
          @JsonKey(fromJson: _parseDouble) final double? lat,
          @JsonKey(fromJson: _parseDouble) final double? lng}) =
      _$IncomingAddressImpl;

  factory _IncomingAddress.fromJson(Map<String, dynamic> json) =
      _$IncomingAddressImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  @JsonKey(name: 'address_line')
  String get addressLine;
  @override
  String? get city;
  @override
  String? get district;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get lat;
  @override
  @JsonKey(fromJson: _parseDouble)
  double? get lng;

  /// Create a copy of IncomingAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomingAddressImplCopyWith<_$IncomingAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IncomingPatient _$IncomingPatientFromJson(Map<String, dynamic> json) {
  return _IncomingPatient.fromJson(json);
}

/// @nodoc
mixin _$IncomingPatient {
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this IncomingPatient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IncomingPatient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomingPatientCopyWith<IncomingPatient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomingPatientCopyWith<$Res> {
  factory $IncomingPatientCopyWith(
          IncomingPatient value, $Res Function(IncomingPatient) then) =
      _$IncomingPatientCopyWithImpl<$Res, IncomingPatient>;
  @useResult
  $Res call({@JsonKey(fromJson: _parseInt) int id, String name, String? phone});
}

/// @nodoc
class _$IncomingPatientCopyWithImpl<$Res, $Val extends IncomingPatient>
    implements $IncomingPatientCopyWith<$Res> {
  _$IncomingPatientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomingPatient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = freezed,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomingPatientImplCopyWith<$Res>
    implements $IncomingPatientCopyWith<$Res> {
  factory _$$IncomingPatientImplCopyWith(_$IncomingPatientImpl value,
          $Res Function(_$IncomingPatientImpl) then) =
      __$$IncomingPatientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(fromJson: _parseInt) int id, String name, String? phone});
}

/// @nodoc
class __$$IncomingPatientImplCopyWithImpl<$Res>
    extends _$IncomingPatientCopyWithImpl<$Res, _$IncomingPatientImpl>
    implements _$$IncomingPatientImplCopyWith<$Res> {
  __$$IncomingPatientImplCopyWithImpl(
      _$IncomingPatientImpl _value, $Res Function(_$IncomingPatientImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncomingPatient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = freezed,
  }) {
    return _then(_$IncomingPatientImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncomingPatientImpl implements _IncomingPatient {
  const _$IncomingPatientImpl(
      {@JsonKey(fromJson: _parseInt) required this.id,
      required this.name,
      this.phone});

  factory _$IncomingPatientImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncomingPatientImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  final String name;
  @override
  final String? phone;

  @override
  String toString() {
    return 'IncomingPatient(id: $id, name: $name, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingPatientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, phone);

  /// Create a copy of IncomingPatient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomingPatientImplCopyWith<_$IncomingPatientImpl> get copyWith =>
      __$$IncomingPatientImplCopyWithImpl<_$IncomingPatientImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncomingPatientImplToJson(
      this,
    );
  }
}

abstract class _IncomingPatient implements IncomingPatient {
  const factory _IncomingPatient(
      {@JsonKey(fromJson: _parseInt) required final int id,
      required final String name,
      final String? phone}) = _$IncomingPatientImpl;

  factory _IncomingPatient.fromJson(Map<String, dynamic> json) =
      _$IncomingPatientImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  String get name;
  @override
  String? get phone;

  /// Create a copy of IncomingPatient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomingPatientImplCopyWith<_$IncomingPatientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IncomingOrderDetail _$IncomingOrderDetailFromJson(Map<String, dynamic> json) {
  return _IncomingOrderDetail.fromJson(json);
}

/// @nodoc
mixin _$IncomingOrderDetail {
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'drug_id', fromJson: _parseInt)
  int get drugId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseInt)
  int get quantity => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'prescription_image')
  String? get prescriptionImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'requires_prescription')
  bool get requiresPrescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'cod_amount', fromJson: _parseDouble)
  double? get codAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_fee', fromJson: _parseDouble)
  double? get deliveryFee => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;
  IncomingDrug? get drug => throw _privateConstructorUsedError;
  @JsonKey(name: 'patient_address')
  IncomingAddress? get patientAddress => throw _privateConstructorUsedError;
  IncomingPatient? get patient => throw _privateConstructorUsedError;

  /// Serializes this IncomingOrderDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IncomingOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomingOrderDetailCopyWith<IncomingOrderDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomingOrderDetailCopyWith<$Res> {
  factory $IncomingOrderDetailCopyWith(
          IncomingOrderDetail value, $Res Function(IncomingOrderDetail) then) =
      _$IncomingOrderDetailCopyWithImpl<$Res, IncomingOrderDetail>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(name: 'drug_id', fromJson: _parseInt) int drugId,
      @JsonKey(fromJson: _parseInt) int quantity,
      String? notes,
      @JsonKey(name: 'prescription_image') String? prescriptionImage,
      @JsonKey(name: 'requires_prescription') bool requiresPrescription,
      @JsonKey(name: 'cod_amount', fromJson: _parseDouble) double? codAmount,
      @JsonKey(name: 'delivery_fee', fromJson: _parseDouble)
      double? deliveryFee,
      @JsonKey(name: 'payment_method') String? paymentMethod,
      IncomingDrug? drug,
      @JsonKey(name: 'patient_address') IncomingAddress? patientAddress,
      IncomingPatient? patient});

  $IncomingDrugCopyWith<$Res>? get drug;
  $IncomingAddressCopyWith<$Res>? get patientAddress;
  $IncomingPatientCopyWith<$Res>? get patient;
}

/// @nodoc
class _$IncomingOrderDetailCopyWithImpl<$Res, $Val extends IncomingOrderDetail>
    implements $IncomingOrderDetailCopyWith<$Res> {
  _$IncomingOrderDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomingOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? drugId = null,
    Object? quantity = null,
    Object? notes = freezed,
    Object? prescriptionImage = freezed,
    Object? requiresPrescription = null,
    Object? codAmount = freezed,
    Object? deliveryFee = freezed,
    Object? paymentMethod = freezed,
    Object? drug = freezed,
    Object? patientAddress = freezed,
    Object? patient = freezed,
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
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      prescriptionImage: freezed == prescriptionImage
          ? _value.prescriptionImage
          : prescriptionImage // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresPrescription: null == requiresPrescription
          ? _value.requiresPrescription
          : requiresPrescription // ignore: cast_nullable_to_non_nullable
              as bool,
      codAmount: freezed == codAmount
          ? _value.codAmount
          : codAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      deliveryFee: freezed == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      drug: freezed == drug
          ? _value.drug
          : drug // ignore: cast_nullable_to_non_nullable
              as IncomingDrug?,
      patientAddress: freezed == patientAddress
          ? _value.patientAddress
          : patientAddress // ignore: cast_nullable_to_non_nullable
              as IncomingAddress?,
      patient: freezed == patient
          ? _value.patient
          : patient // ignore: cast_nullable_to_non_nullable
              as IncomingPatient?,
    ) as $Val);
  }

  /// Create a copy of IncomingOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IncomingDrugCopyWith<$Res>? get drug {
    if (_value.drug == null) {
      return null;
    }

    return $IncomingDrugCopyWith<$Res>(_value.drug!, (value) {
      return _then(_value.copyWith(drug: value) as $Val);
    });
  }

  /// Create a copy of IncomingOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IncomingAddressCopyWith<$Res>? get patientAddress {
    if (_value.patientAddress == null) {
      return null;
    }

    return $IncomingAddressCopyWith<$Res>(_value.patientAddress!, (value) {
      return _then(_value.copyWith(patientAddress: value) as $Val);
    });
  }

  /// Create a copy of IncomingOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IncomingPatientCopyWith<$Res>? get patient {
    if (_value.patient == null) {
      return null;
    }

    return $IncomingPatientCopyWith<$Res>(_value.patient!, (value) {
      return _then(_value.copyWith(patient: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IncomingOrderDetailImplCopyWith<$Res>
    implements $IncomingOrderDetailCopyWith<$Res> {
  factory _$$IncomingOrderDetailImplCopyWith(_$IncomingOrderDetailImpl value,
          $Res Function(_$IncomingOrderDetailImpl) then) =
      __$$IncomingOrderDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(name: 'drug_id', fromJson: _parseInt) int drugId,
      @JsonKey(fromJson: _parseInt) int quantity,
      String? notes,
      @JsonKey(name: 'prescription_image') String? prescriptionImage,
      @JsonKey(name: 'requires_prescription') bool requiresPrescription,
      @JsonKey(name: 'cod_amount', fromJson: _parseDouble) double? codAmount,
      @JsonKey(name: 'delivery_fee', fromJson: _parseDouble)
      double? deliveryFee,
      @JsonKey(name: 'payment_method') String? paymentMethod,
      IncomingDrug? drug,
      @JsonKey(name: 'patient_address') IncomingAddress? patientAddress,
      IncomingPatient? patient});

  @override
  $IncomingDrugCopyWith<$Res>? get drug;
  @override
  $IncomingAddressCopyWith<$Res>? get patientAddress;
  @override
  $IncomingPatientCopyWith<$Res>? get patient;
}

/// @nodoc
class __$$IncomingOrderDetailImplCopyWithImpl<$Res>
    extends _$IncomingOrderDetailCopyWithImpl<$Res, _$IncomingOrderDetailImpl>
    implements _$$IncomingOrderDetailImplCopyWith<$Res> {
  __$$IncomingOrderDetailImplCopyWithImpl(_$IncomingOrderDetailImpl _value,
      $Res Function(_$IncomingOrderDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncomingOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? drugId = null,
    Object? quantity = null,
    Object? notes = freezed,
    Object? prescriptionImage = freezed,
    Object? requiresPrescription = null,
    Object? codAmount = freezed,
    Object? deliveryFee = freezed,
    Object? paymentMethod = freezed,
    Object? drug = freezed,
    Object? patientAddress = freezed,
    Object? patient = freezed,
  }) {
    return _then(_$IncomingOrderDetailImpl(
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
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      prescriptionImage: freezed == prescriptionImage
          ? _value.prescriptionImage
          : prescriptionImage // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresPrescription: null == requiresPrescription
          ? _value.requiresPrescription
          : requiresPrescription // ignore: cast_nullable_to_non_nullable
              as bool,
      codAmount: freezed == codAmount
          ? _value.codAmount
          : codAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      deliveryFee: freezed == deliveryFee
          ? _value.deliveryFee
          : deliveryFee // ignore: cast_nullable_to_non_nullable
              as double?,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      drug: freezed == drug
          ? _value.drug
          : drug // ignore: cast_nullable_to_non_nullable
              as IncomingDrug?,
      patientAddress: freezed == patientAddress
          ? _value.patientAddress
          : patientAddress // ignore: cast_nullable_to_non_nullable
              as IncomingAddress?,
      patient: freezed == patient
          ? _value.patient
          : patient // ignore: cast_nullable_to_non_nullable
              as IncomingPatient?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncomingOrderDetailImpl implements _IncomingOrderDetail {
  const _$IncomingOrderDetailImpl(
      {@JsonKey(fromJson: _parseInt) required this.id,
      @JsonKey(name: 'drug_id', fromJson: _parseInt) required this.drugId,
      @JsonKey(fromJson: _parseInt) required this.quantity,
      this.notes,
      @JsonKey(name: 'prescription_image') this.prescriptionImage,
      @JsonKey(name: 'requires_prescription') this.requiresPrescription = false,
      @JsonKey(name: 'cod_amount', fromJson: _parseDouble) this.codAmount,
      @JsonKey(name: 'delivery_fee', fromJson: _parseDouble) this.deliveryFee,
      @JsonKey(name: 'payment_method') this.paymentMethod,
      this.drug,
      @JsonKey(name: 'patient_address') this.patientAddress,
      this.patient});

  factory _$IncomingOrderDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncomingOrderDetailImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  @JsonKey(name: 'drug_id', fromJson: _parseInt)
  final int drugId;
  @override
  @JsonKey(fromJson: _parseInt)
  final int quantity;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'prescription_image')
  final String? prescriptionImage;
  @override
  @JsonKey(name: 'requires_prescription')
  final bool requiresPrescription;
  @override
  @JsonKey(name: 'cod_amount', fromJson: _parseDouble)
  final double? codAmount;
  @override
  @JsonKey(name: 'delivery_fee', fromJson: _parseDouble)
  final double? deliveryFee;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @override
  final IncomingDrug? drug;
  @override
  @JsonKey(name: 'patient_address')
  final IncomingAddress? patientAddress;
  @override
  final IncomingPatient? patient;

  @override
  String toString() {
    return 'IncomingOrderDetail(id: $id, drugId: $drugId, quantity: $quantity, notes: $notes, prescriptionImage: $prescriptionImage, requiresPrescription: $requiresPrescription, codAmount: $codAmount, deliveryFee: $deliveryFee, paymentMethod: $paymentMethod, drug: $drug, patientAddress: $patientAddress, patient: $patient)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingOrderDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.drugId, drugId) || other.drugId == drugId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.prescriptionImage, prescriptionImage) ||
                other.prescriptionImage == prescriptionImage) &&
            (identical(other.requiresPrescription, requiresPrescription) ||
                other.requiresPrescription == requiresPrescription) &&
            (identical(other.codAmount, codAmount) ||
                other.codAmount == codAmount) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.drug, drug) || other.drug == drug) &&
            (identical(other.patientAddress, patientAddress) ||
                other.patientAddress == patientAddress) &&
            (identical(other.patient, patient) || other.patient == patient));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      drugId,
      quantity,
      notes,
      prescriptionImage,
      requiresPrescription,
      codAmount,
      deliveryFee,
      paymentMethod,
      drug,
      patientAddress,
      patient);

  /// Create a copy of IncomingOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomingOrderDetailImplCopyWith<_$IncomingOrderDetailImpl> get copyWith =>
      __$$IncomingOrderDetailImplCopyWithImpl<_$IncomingOrderDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncomingOrderDetailImplToJson(
      this,
    );
  }
}

abstract class _IncomingOrderDetail implements IncomingOrderDetail {
  const factory _IncomingOrderDetail(
      {@JsonKey(fromJson: _parseInt) required final int id,
      @JsonKey(name: 'drug_id', fromJson: _parseInt) required final int drugId,
      @JsonKey(fromJson: _parseInt) required final int quantity,
      final String? notes,
      @JsonKey(name: 'prescription_image') final String? prescriptionImage,
      @JsonKey(name: 'requires_prescription') final bool requiresPrescription,
      @JsonKey(name: 'cod_amount', fromJson: _parseDouble)
      final double? codAmount,
      @JsonKey(name: 'delivery_fee', fromJson: _parseDouble)
      final double? deliveryFee,
      @JsonKey(name: 'payment_method') final String? paymentMethod,
      final IncomingDrug? drug,
      @JsonKey(name: 'patient_address') final IncomingAddress? patientAddress,
      final IncomingPatient? patient}) = _$IncomingOrderDetailImpl;

  factory _IncomingOrderDetail.fromJson(Map<String, dynamic> json) =
      _$IncomingOrderDetailImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  @JsonKey(name: 'drug_id', fromJson: _parseInt)
  int get drugId;
  @override
  @JsonKey(fromJson: _parseInt)
  int get quantity;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'prescription_image')
  String? get prescriptionImage;
  @override
  @JsonKey(name: 'requires_prescription')
  bool get requiresPrescription;
  @override
  @JsonKey(name: 'cod_amount', fromJson: _parseDouble)
  double? get codAmount;
  @override
  @JsonKey(name: 'delivery_fee', fromJson: _parseDouble)
  double? get deliveryFee;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;
  @override
  IncomingDrug? get drug;
  @override
  @JsonKey(name: 'patient_address')
  IncomingAddress? get patientAddress;
  @override
  IncomingPatient? get patient;

  /// Create a copy of IncomingOrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomingOrderDetailImplCopyWith<_$IncomingOrderDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IncomingOrder _$IncomingOrderFromJson(Map<String, dynamic> json) {
  return _IncomingOrder.fromJson(json);
}

/// @nodoc
mixin _$IncomingOrder {
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id', fromJson: _parseInt)
  int get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'pharmacy_id', fromJson: _parseInt)
  int get pharmacyId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'sent_at')
  String? get sentAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  String? get expiresAt => throw _privateConstructorUsedError;
  IncomingOrderDetail? get order => throw _privateConstructorUsedError;

  /// Serializes this IncomingOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IncomingOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomingOrderCopyWith<IncomingOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomingOrderCopyWith<$Res> {
  factory $IncomingOrderCopyWith(
          IncomingOrder value, $Res Function(IncomingOrder) then) =
      _$IncomingOrderCopyWithImpl<$Res, IncomingOrder>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(name: 'order_id', fromJson: _parseInt) int orderId,
      @JsonKey(name: 'pharmacy_id', fromJson: _parseInt) int pharmacyId,
      String status,
      @JsonKey(name: 'sent_at') String? sentAt,
      @JsonKey(name: 'expires_at') String? expiresAt,
      IncomingOrderDetail? order});

  $IncomingOrderDetailCopyWith<$Res>? get order;
}

/// @nodoc
class _$IncomingOrderCopyWithImpl<$Res, $Val extends IncomingOrder>
    implements $IncomingOrderCopyWith<$Res> {
  _$IncomingOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomingOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? pharmacyId = null,
    Object? status = null,
    Object? sentAt = freezed,
    Object? expiresAt = freezed,
    Object? order = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      pharmacyId: null == pharmacyId
          ? _value.pharmacyId
          : pharmacyId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
      order: freezed == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as IncomingOrderDetail?,
    ) as $Val);
  }

  /// Create a copy of IncomingOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IncomingOrderDetailCopyWith<$Res>? get order {
    if (_value.order == null) {
      return null;
    }

    return $IncomingOrderDetailCopyWith<$Res>(_value.order!, (value) {
      return _then(_value.copyWith(order: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IncomingOrderImplCopyWith<$Res>
    implements $IncomingOrderCopyWith<$Res> {
  factory _$$IncomingOrderImplCopyWith(
          _$IncomingOrderImpl value, $Res Function(_$IncomingOrderImpl) then) =
      __$$IncomingOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      @JsonKey(name: 'order_id', fromJson: _parseInt) int orderId,
      @JsonKey(name: 'pharmacy_id', fromJson: _parseInt) int pharmacyId,
      String status,
      @JsonKey(name: 'sent_at') String? sentAt,
      @JsonKey(name: 'expires_at') String? expiresAt,
      IncomingOrderDetail? order});

  @override
  $IncomingOrderDetailCopyWith<$Res>? get order;
}

/// @nodoc
class __$$IncomingOrderImplCopyWithImpl<$Res>
    extends _$IncomingOrderCopyWithImpl<$Res, _$IncomingOrderImpl>
    implements _$$IncomingOrderImplCopyWith<$Res> {
  __$$IncomingOrderImplCopyWithImpl(
      _$IncomingOrderImpl _value, $Res Function(_$IncomingOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of IncomingOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? pharmacyId = null,
    Object? status = null,
    Object? sentAt = freezed,
    Object? expiresAt = freezed,
    Object? order = freezed,
  }) {
    return _then(_$IncomingOrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      pharmacyId: null == pharmacyId
          ? _value.pharmacyId
          : pharmacyId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: freezed == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
      order: freezed == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as IncomingOrderDetail?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncomingOrderImpl implements _IncomingOrder {
  const _$IncomingOrderImpl(
      {@JsonKey(fromJson: _parseInt) required this.id,
      @JsonKey(name: 'order_id', fromJson: _parseInt) required this.orderId,
      @JsonKey(name: 'pharmacy_id', fromJson: _parseInt)
      required this.pharmacyId,
      required this.status,
      @JsonKey(name: 'sent_at') this.sentAt,
      @JsonKey(name: 'expires_at') this.expiresAt,
      this.order});

  factory _$IncomingOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncomingOrderImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  @JsonKey(name: 'order_id', fromJson: _parseInt)
  final int orderId;
  @override
  @JsonKey(name: 'pharmacy_id', fromJson: _parseInt)
  final int pharmacyId;
  @override
  final String status;
  @override
  @JsonKey(name: 'sent_at')
  final String? sentAt;
  @override
  @JsonKey(name: 'expires_at')
  final String? expiresAt;
  @override
  final IncomingOrderDetail? order;

  @override
  String toString() {
    return 'IncomingOrder(id: $id, orderId: $orderId, pharmacyId: $pharmacyId, status: $status, sentAt: $sentAt, expiresAt: $expiresAt, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.pharmacyId, pharmacyId) ||
                other.pharmacyId == pharmacyId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orderId, pharmacyId, status, sentAt, expiresAt, order);

  /// Create a copy of IncomingOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomingOrderImplCopyWith<_$IncomingOrderImpl> get copyWith =>
      __$$IncomingOrderImplCopyWithImpl<_$IncomingOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncomingOrderImplToJson(
      this,
    );
  }
}

abstract class _IncomingOrder implements IncomingOrder {
  const factory _IncomingOrder(
      {@JsonKey(fromJson: _parseInt) required final int id,
      @JsonKey(name: 'order_id', fromJson: _parseInt)
      required final int orderId,
      @JsonKey(name: 'pharmacy_id', fromJson: _parseInt)
      required final int pharmacyId,
      required final String status,
      @JsonKey(name: 'sent_at') final String? sentAt,
      @JsonKey(name: 'expires_at') final String? expiresAt,
      final IncomingOrderDetail? order}) = _$IncomingOrderImpl;

  factory _IncomingOrder.fromJson(Map<String, dynamic> json) =
      _$IncomingOrderImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  @JsonKey(name: 'order_id', fromJson: _parseInt)
  int get orderId;
  @override
  @JsonKey(name: 'pharmacy_id', fromJson: _parseInt)
  int get pharmacyId;
  @override
  String get status;
  @override
  @JsonKey(name: 'sent_at')
  String? get sentAt;
  @override
  @JsonKey(name: 'expires_at')
  String? get expiresAt;
  @override
  IncomingOrderDetail? get order;

  /// Create a copy of IncomingOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomingOrderImplCopyWith<_$IncomingOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
