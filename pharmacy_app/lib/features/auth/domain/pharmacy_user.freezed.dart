// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pharmacy_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Pharmacy _$PharmacyFromJson(Map<String, dynamic> json) {
  return _Pharmacy.fromJson(json);
}

/// @nodoc
mixin _$Pharmacy {
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get district => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get lat => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseDouble)
  double? get lng => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_radius_km', fromJson: _parseIntNullable)
  int? get deliveryRadiusKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_delivery')
  bool get hasDelivery => throw _privateConstructorUsedError;

  /// Serializes this Pharmacy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Pharmacy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PharmacyCopyWith<Pharmacy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PharmacyCopyWith<$Res> {
  factory $PharmacyCopyWith(Pharmacy value, $Res Function(Pharmacy) then) =
      _$PharmacyCopyWithImpl<$Res, Pharmacy>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      String name,
      String? phone,
      String? address,
      String? city,
      String? district,
      @JsonKey(fromJson: _parseDouble) double? lat,
      @JsonKey(fromJson: _parseDouble) double? lng,
      @JsonKey(name: 'delivery_radius_km', fromJson: _parseIntNullable)
      int? deliveryRadiusKm,
      @JsonKey(name: 'has_delivery') bool hasDelivery});
}

/// @nodoc
class _$PharmacyCopyWithImpl<$Res, $Val extends Pharmacy>
    implements $PharmacyCopyWith<$Res> {
  _$PharmacyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Pharmacy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? district = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? deliveryRadiusKm = freezed,
    Object? hasDelivery = null,
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
      deliveryRadiusKm: freezed == deliveryRadiusKm
          ? _value.deliveryRadiusKm
          : deliveryRadiusKm // ignore: cast_nullable_to_non_nullable
              as int?,
      hasDelivery: null == hasDelivery
          ? _value.hasDelivery
          : hasDelivery // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PharmacyImplCopyWith<$Res>
    implements $PharmacyCopyWith<$Res> {
  factory _$$PharmacyImplCopyWith(
          _$PharmacyImpl value, $Res Function(_$PharmacyImpl) then) =
      __$$PharmacyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      String name,
      String? phone,
      String? address,
      String? city,
      String? district,
      @JsonKey(fromJson: _parseDouble) double? lat,
      @JsonKey(fromJson: _parseDouble) double? lng,
      @JsonKey(name: 'delivery_radius_km', fromJson: _parseIntNullable)
      int? deliveryRadiusKm,
      @JsonKey(name: 'has_delivery') bool hasDelivery});
}

/// @nodoc
class __$$PharmacyImplCopyWithImpl<$Res>
    extends _$PharmacyCopyWithImpl<$Res, _$PharmacyImpl>
    implements _$$PharmacyImplCopyWith<$Res> {
  __$$PharmacyImplCopyWithImpl(
      _$PharmacyImpl _value, $Res Function(_$PharmacyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Pharmacy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? district = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? deliveryRadiusKm = freezed,
    Object? hasDelivery = null,
  }) {
    return _then(_$PharmacyImpl(
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
      deliveryRadiusKm: freezed == deliveryRadiusKm
          ? _value.deliveryRadiusKm
          : deliveryRadiusKm // ignore: cast_nullable_to_non_nullable
              as int?,
      hasDelivery: null == hasDelivery
          ? _value.hasDelivery
          : hasDelivery // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PharmacyImpl implements _Pharmacy {
  const _$PharmacyImpl(
      {@JsonKey(fromJson: _parseInt) required this.id,
      required this.name,
      this.phone,
      this.address,
      this.city,
      this.district,
      @JsonKey(fromJson: _parseDouble) this.lat,
      @JsonKey(fromJson: _parseDouble) this.lng,
      @JsonKey(name: 'delivery_radius_km', fromJson: _parseIntNullable)
      this.deliveryRadiusKm,
      @JsonKey(name: 'has_delivery') this.hasDelivery = false});

  factory _$PharmacyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PharmacyImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? address;
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
  @JsonKey(name: 'delivery_radius_km', fromJson: _parseIntNullable)
  final int? deliveryRadiusKm;
  @override
  @JsonKey(name: 'has_delivery')
  final bool hasDelivery;

  @override
  String toString() {
    return 'Pharmacy(id: $id, name: $name, phone: $phone, address: $address, city: $city, district: $district, lat: $lat, lng: $lng, deliveryRadiusKm: $deliveryRadiusKm, hasDelivery: $hasDelivery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PharmacyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.deliveryRadiusKm, deliveryRadiusKm) ||
                other.deliveryRadiusKm == deliveryRadiusKm) &&
            (identical(other.hasDelivery, hasDelivery) ||
                other.hasDelivery == hasDelivery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, phone, address, city,
      district, lat, lng, deliveryRadiusKm, hasDelivery);

  /// Create a copy of Pharmacy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PharmacyImplCopyWith<_$PharmacyImpl> get copyWith =>
      __$$PharmacyImplCopyWithImpl<_$PharmacyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PharmacyImplToJson(
      this,
    );
  }
}

abstract class _Pharmacy implements Pharmacy {
  const factory _Pharmacy(
      {@JsonKey(fromJson: _parseInt) required final int id,
      required final String name,
      final String? phone,
      final String? address,
      final String? city,
      final String? district,
      @JsonKey(fromJson: _parseDouble) final double? lat,
      @JsonKey(fromJson: _parseDouble) final double? lng,
      @JsonKey(name: 'delivery_radius_km', fromJson: _parseIntNullable)
      final int? deliveryRadiusKm,
      @JsonKey(name: 'has_delivery') final bool hasDelivery}) = _$PharmacyImpl;

  factory _Pharmacy.fromJson(Map<String, dynamic> json) =
      _$PharmacyImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  String get name;
  @override
  String? get phone;
  @override
  String? get address;
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
  @JsonKey(name: 'delivery_radius_km', fromJson: _parseIntNullable)
  int? get deliveryRadiusKm;
  @override
  @JsonKey(name: 'has_delivery')
  bool get hasDelivery;

  /// Create a copy of Pharmacy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PharmacyImplCopyWith<_$PharmacyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PharmacyUser _$PharmacyUserFromJson(Map<String, dynamic> json) {
  return _PharmacyUser.fromJson(json);
}

/// @nodoc
mixin _$PharmacyUser {
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'pharmacy_id', fromJson: _parseIntNullable)
  int? get pharmacyId => throw _privateConstructorUsedError;
  Pharmacy? get pharmacy => throw _privateConstructorUsedError;

  /// Serializes this PharmacyUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PharmacyUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PharmacyUserCopyWith<PharmacyUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PharmacyUserCopyWith<$Res> {
  factory $PharmacyUserCopyWith(
          PharmacyUser value, $Res Function(PharmacyUser) then) =
      _$PharmacyUserCopyWithImpl<$Res, PharmacyUser>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      String name,
      String email,
      String role,
      @JsonKey(name: 'pharmacy_id', fromJson: _parseIntNullable)
      int? pharmacyId,
      Pharmacy? pharmacy});

  $PharmacyCopyWith<$Res>? get pharmacy;
}

/// @nodoc
class _$PharmacyUserCopyWithImpl<$Res, $Val extends PharmacyUser>
    implements $PharmacyUserCopyWith<$Res> {
  _$PharmacyUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PharmacyUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? role = null,
    Object? pharmacyId = freezed,
    Object? pharmacy = freezed,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      pharmacyId: freezed == pharmacyId
          ? _value.pharmacyId
          : pharmacyId // ignore: cast_nullable_to_non_nullable
              as int?,
      pharmacy: freezed == pharmacy
          ? _value.pharmacy
          : pharmacy // ignore: cast_nullable_to_non_nullable
              as Pharmacy?,
    ) as $Val);
  }

  /// Create a copy of PharmacyUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PharmacyCopyWith<$Res>? get pharmacy {
    if (_value.pharmacy == null) {
      return null;
    }

    return $PharmacyCopyWith<$Res>(_value.pharmacy!, (value) {
      return _then(_value.copyWith(pharmacy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PharmacyUserImplCopyWith<$Res>
    implements $PharmacyUserCopyWith<$Res> {
  factory _$$PharmacyUserImplCopyWith(
          _$PharmacyUserImpl value, $Res Function(_$PharmacyUserImpl) then) =
      __$$PharmacyUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseInt) int id,
      String name,
      String email,
      String role,
      @JsonKey(name: 'pharmacy_id', fromJson: _parseIntNullable)
      int? pharmacyId,
      Pharmacy? pharmacy});

  @override
  $PharmacyCopyWith<$Res>? get pharmacy;
}

/// @nodoc
class __$$PharmacyUserImplCopyWithImpl<$Res>
    extends _$PharmacyUserCopyWithImpl<$Res, _$PharmacyUserImpl>
    implements _$$PharmacyUserImplCopyWith<$Res> {
  __$$PharmacyUserImplCopyWithImpl(
      _$PharmacyUserImpl _value, $Res Function(_$PharmacyUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of PharmacyUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? role = null,
    Object? pharmacyId = freezed,
    Object? pharmacy = freezed,
  }) {
    return _then(_$PharmacyUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      pharmacyId: freezed == pharmacyId
          ? _value.pharmacyId
          : pharmacyId // ignore: cast_nullable_to_non_nullable
              as int?,
      pharmacy: freezed == pharmacy
          ? _value.pharmacy
          : pharmacy // ignore: cast_nullable_to_non_nullable
              as Pharmacy?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PharmacyUserImpl implements _PharmacyUser {
  const _$PharmacyUserImpl(
      {@JsonKey(fromJson: _parseInt) required this.id,
      required this.name,
      required this.email,
      required this.role,
      @JsonKey(name: 'pharmacy_id', fromJson: _parseIntNullable)
      this.pharmacyId,
      this.pharmacy});

  factory _$PharmacyUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$PharmacyUserImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String role;
  @override
  @JsonKey(name: 'pharmacy_id', fromJson: _parseIntNullable)
  final int? pharmacyId;
  @override
  final Pharmacy? pharmacy;

  @override
  String toString() {
    return 'PharmacyUser(id: $id, name: $name, email: $email, role: $role, pharmacyId: $pharmacyId, pharmacy: $pharmacy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PharmacyUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.pharmacyId, pharmacyId) ||
                other.pharmacyId == pharmacyId) &&
            (identical(other.pharmacy, pharmacy) ||
                other.pharmacy == pharmacy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, email, role, pharmacyId, pharmacy);

  /// Create a copy of PharmacyUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PharmacyUserImplCopyWith<_$PharmacyUserImpl> get copyWith =>
      __$$PharmacyUserImplCopyWithImpl<_$PharmacyUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PharmacyUserImplToJson(
      this,
    );
  }
}

abstract class _PharmacyUser implements PharmacyUser {
  const factory _PharmacyUser(
      {@JsonKey(fromJson: _parseInt) required final int id,
      required final String name,
      required final String email,
      required final String role,
      @JsonKey(name: 'pharmacy_id', fromJson: _parseIntNullable)
      final int? pharmacyId,
      final Pharmacy? pharmacy}) = _$PharmacyUserImpl;

  factory _PharmacyUser.fromJson(Map<String, dynamic> json) =
      _$PharmacyUserImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get role;
  @override
  @JsonKey(name: 'pharmacy_id', fromJson: _parseIntNullable)
  int? get pharmacyId;
  @override
  Pharmacy? get pharmacy;

  /// Create a copy of PharmacyUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PharmacyUserImplCopyWith<_$PharmacyUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
