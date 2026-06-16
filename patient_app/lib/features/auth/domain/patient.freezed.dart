// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PatientAddress _$PatientAddressFromJson(Map<String, dynamic> json) {
  return _PatientAddress.fromJson(json);
}

/// @nodoc
mixin _$PatientAddress {
  int get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line')
  String get addressLine => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get district => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get lat => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get lng => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this PatientAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PatientAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PatientAddressCopyWith<PatientAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientAddressCopyWith<$Res> {
  factory $PatientAddressCopyWith(
          PatientAddress value, $Res Function(PatientAddress) then) =
      _$PatientAddressCopyWithImpl<$Res, PatientAddress>;
  @useResult
  $Res call(
      {int id,
      String label,
      @JsonKey(name: 'address_line') String addressLine,
      String? city,
      String? district,
      @JsonKey(fromJson: _parseDouble) double? lat,
      @JsonKey(fromJson: _parseDouble) double? lng,
      @JsonKey(name: 'is_default') bool isDefault});
}

/// @nodoc
class _$PatientAddressCopyWithImpl<$Res, $Val extends PatientAddress>
    implements $PatientAddressCopyWith<$Res> {
  _$PatientAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PatientAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? addressLine = null,
    Object? city = freezed,
    Object? district = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? isDefault = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
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
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PatientAddressImplCopyWith<$Res>
    implements $PatientAddressCopyWith<$Res> {
  factory _$$PatientAddressImplCopyWith(_$PatientAddressImpl value,
          $Res Function(_$PatientAddressImpl) then) =
      __$$PatientAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String label,
      @JsonKey(name: 'address_line') String addressLine,
      String? city,
      String? district,
      @JsonKey(fromJson: _parseDouble) double? lat,
      @JsonKey(fromJson: _parseDouble) double? lng,
      @JsonKey(name: 'is_default') bool isDefault});
}

/// @nodoc
class __$$PatientAddressImplCopyWithImpl<$Res>
    extends _$PatientAddressCopyWithImpl<$Res, _$PatientAddressImpl>
    implements _$$PatientAddressImplCopyWith<$Res> {
  __$$PatientAddressImplCopyWithImpl(
      _$PatientAddressImpl _value, $Res Function(_$PatientAddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of PatientAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? addressLine = null,
    Object? city = freezed,
    Object? district = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? isDefault = null,
  }) {
    return _then(_$PatientAddressImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
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
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientAddressImpl implements _PatientAddress {
  const _$PatientAddressImpl(
      {required this.id,
      required this.label,
      @JsonKey(name: 'address_line') required this.addressLine,
      this.city,
      this.district,
      @JsonKey(fromJson: _parseDouble) this.lat,
      @JsonKey(fromJson: _parseDouble) this.lng,
      @JsonKey(name: 'is_default') this.isDefault = false});

  factory _$PatientAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientAddressImplFromJson(json);

  @override
  final int id;
  @override
  final String label;
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
  @JsonKey(name: 'is_default')
  final bool isDefault;

  @override
  String toString() {
    return 'PatientAddress(id: $id, label: $label, addressLine: $addressLine, city: $city, district: $district, lat: $lat, lng: $lng, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientAddressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.addressLine, addressLine) ||
                other.addressLine == addressLine) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, label, addressLine, city, district, lat, lng, isDefault);

  /// Create a copy of PatientAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientAddressImplCopyWith<_$PatientAddressImpl> get copyWith =>
      __$$PatientAddressImplCopyWithImpl<_$PatientAddressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientAddressImplToJson(
      this,
    );
  }
}

abstract class _PatientAddress implements PatientAddress {
  const factory _PatientAddress(
          {required final int id,
          required final String label,
          @JsonKey(name: 'address_line') required final String addressLine,
          final String? city,
          final String? district,
          @JsonKey(fromJson: _parseDouble) final double? lat,
          @JsonKey(fromJson: _parseDouble) final double? lng,
          @JsonKey(name: 'is_default') final bool isDefault}) =
      _$PatientAddressImpl;

  factory _PatientAddress.fromJson(Map<String, dynamic> json) =
      _$PatientAddressImpl.fromJson;

  @override
  int get id;
  @override
  String get label;
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
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;

  /// Create a copy of PatientAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatientAddressImplCopyWith<_$PatientAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Patient _$PatientFromJson(Map<String, dynamic> json) {
  return _Patient.fromJson(json);
}

/// @nodoc
mixin _$Patient {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  List<PatientAddress> get addresses => throw _privateConstructorUsedError;

  /// Serializes this Patient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PatientCopyWith<Patient> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientCopyWith<$Res> {
  factory $PatientCopyWith(Patient value, $Res Function(Patient) then) =
      _$PatientCopyWithImpl<$Res, Patient>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? email,
      String? phone,
      List<PatientAddress> addresses});
}

/// @nodoc
class _$PatientCopyWithImpl<$Res, $Val extends Patient>
    implements $PatientCopyWith<$Res> {
  _$PatientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? addresses = null,
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
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      addresses: null == addresses
          ? _value.addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<PatientAddress>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PatientImplCopyWith<$Res> implements $PatientCopyWith<$Res> {
  factory _$$PatientImplCopyWith(
          _$PatientImpl value, $Res Function(_$PatientImpl) then) =
      __$$PatientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? email,
      String? phone,
      List<PatientAddress> addresses});
}

/// @nodoc
class __$$PatientImplCopyWithImpl<$Res>
    extends _$PatientCopyWithImpl<$Res, _$PatientImpl>
    implements _$$PatientImplCopyWith<$Res> {
  __$$PatientImplCopyWithImpl(
      _$PatientImpl _value, $Res Function(_$PatientImpl) _then)
      : super(_value, _then);

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? addresses = null,
  }) {
    return _then(_$PatientImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      addresses: null == addresses
          ? _value._addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<PatientAddress>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientImpl implements _Patient {
  const _$PatientImpl(
      {required this.id,
      required this.name,
      this.email,
      this.phone,
      final List<PatientAddress> addresses = const []})
      : _addresses = addresses;

  factory _$PatientImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? email;
  @override
  final String? phone;
  final List<PatientAddress> _addresses;
  @override
  @JsonKey()
  List<PatientAddress> get addresses {
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addresses);
  }

  @override
  String toString() {
    return 'Patient(id: $id, name: $name, email: $email, phone: $phone, addresses: $addresses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            const DeepCollectionEquality()
                .equals(other._addresses, _addresses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email, phone,
      const DeepCollectionEquality().hash(_addresses));

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientImplCopyWith<_$PatientImpl> get copyWith =>
      __$$PatientImplCopyWithImpl<_$PatientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientImplToJson(
      this,
    );
  }
}

abstract class _Patient implements Patient {
  const factory _Patient(
      {required final int id,
      required final String name,
      final String? email,
      final String? phone,
      final List<PatientAddress> addresses}) = _$PatientImpl;

  factory _Patient.fromJson(Map<String, dynamic> json) = _$PatientImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  List<PatientAddress> get addresses;

  /// Create a copy of Patient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatientImplCopyWith<_$PatientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
