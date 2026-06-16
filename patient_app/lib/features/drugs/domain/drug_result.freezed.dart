// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drug_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DrugResult _$DrugResultFromJson(Map<String, dynamic> json) {
  return _DrugResult.fromJson(json);
}

/// @nodoc
mixin _$DrugResult {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_ar')
  String get nameAr => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_en')
  String get nameEn => throw _privateConstructorUsedError;
  @JsonKey(name: 'scientific_name')
  String? get scientificName => throw _privateConstructorUsedError;
  String? get form => throw _privateConstructorUsedError;
  String? get strength => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'official_price_egp', fromJson: _parseDouble)
  double? get officialPriceEgp => throw _privateConstructorUsedError;
  @JsonKey(name: 'requires_prescription')
  bool get requiresPrescription => throw _privateConstructorUsedError;
  bool get available => throw _privateConstructorUsedError;

  /// Serializes this DrugResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DrugResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DrugResultCopyWith<DrugResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DrugResultCopyWith<$Res> {
  factory $DrugResultCopyWith(
          DrugResult value, $Res Function(DrugResult) then) =
      _$DrugResultCopyWithImpl<$Res, DrugResult>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'name_ar') String nameAr,
      @JsonKey(name: 'name_en') String nameEn,
      @JsonKey(name: 'scientific_name') String? scientificName,
      String? form,
      String? strength,
      String? unit,
      @JsonKey(name: 'official_price_egp', fromJson: _parseDouble)
      double? officialPriceEgp,
      @JsonKey(name: 'requires_prescription') bool requiresPrescription,
      bool available});
}

/// @nodoc
class _$DrugResultCopyWithImpl<$Res, $Val extends DrugResult>
    implements $DrugResultCopyWith<$Res> {
  _$DrugResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DrugResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? scientificName = freezed,
    Object? form = freezed,
    Object? strength = freezed,
    Object? unit = freezed,
    Object? officialPriceEgp = freezed,
    Object? requiresPrescription = null,
    Object? available = null,
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
      scientificName: freezed == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String?,
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
      officialPriceEgp: freezed == officialPriceEgp
          ? _value.officialPriceEgp
          : officialPriceEgp // ignore: cast_nullable_to_non_nullable
              as double?,
      requiresPrescription: null == requiresPrescription
          ? _value.requiresPrescription
          : requiresPrescription // ignore: cast_nullable_to_non_nullable
              as bool,
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DrugResultImplCopyWith<$Res>
    implements $DrugResultCopyWith<$Res> {
  factory _$$DrugResultImplCopyWith(
          _$DrugResultImpl value, $Res Function(_$DrugResultImpl) then) =
      __$$DrugResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'name_ar') String nameAr,
      @JsonKey(name: 'name_en') String nameEn,
      @JsonKey(name: 'scientific_name') String? scientificName,
      String? form,
      String? strength,
      String? unit,
      @JsonKey(name: 'official_price_egp', fromJson: _parseDouble)
      double? officialPriceEgp,
      @JsonKey(name: 'requires_prescription') bool requiresPrescription,
      bool available});
}

/// @nodoc
class __$$DrugResultImplCopyWithImpl<$Res>
    extends _$DrugResultCopyWithImpl<$Res, _$DrugResultImpl>
    implements _$$DrugResultImplCopyWith<$Res> {
  __$$DrugResultImplCopyWithImpl(
      _$DrugResultImpl _value, $Res Function(_$DrugResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of DrugResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? scientificName = freezed,
    Object? form = freezed,
    Object? strength = freezed,
    Object? unit = freezed,
    Object? officialPriceEgp = freezed,
    Object? requiresPrescription = null,
    Object? available = null,
  }) {
    return _then(_$DrugResultImpl(
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
      scientificName: freezed == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String?,
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
      officialPriceEgp: freezed == officialPriceEgp
          ? _value.officialPriceEgp
          : officialPriceEgp // ignore: cast_nullable_to_non_nullable
              as double?,
      requiresPrescription: null == requiresPrescription
          ? _value.requiresPrescription
          : requiresPrescription // ignore: cast_nullable_to_non_nullable
              as bool,
      available: null == available
          ? _value.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DrugResultImpl implements _DrugResult {
  const _$DrugResultImpl(
      {required this.id,
      @JsonKey(name: 'name_ar') required this.nameAr,
      @JsonKey(name: 'name_en') required this.nameEn,
      @JsonKey(name: 'scientific_name') this.scientificName,
      this.form,
      this.strength,
      this.unit,
      @JsonKey(name: 'official_price_egp', fromJson: _parseDouble)
      this.officialPriceEgp,
      @JsonKey(name: 'requires_prescription') this.requiresPrescription = false,
      this.available = false});

  factory _$DrugResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$DrugResultImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'name_ar')
  final String nameAr;
  @override
  @JsonKey(name: 'name_en')
  final String nameEn;
  @override
  @JsonKey(name: 'scientific_name')
  final String? scientificName;
  @override
  final String? form;
  @override
  final String? strength;
  @override
  final String? unit;
  @override
  @JsonKey(name: 'official_price_egp', fromJson: _parseDouble)
  final double? officialPriceEgp;
  @override
  @JsonKey(name: 'requires_prescription')
  final bool requiresPrescription;
  @override
  @JsonKey()
  final bool available;

  @override
  String toString() {
    return 'DrugResult(id: $id, nameAr: $nameAr, nameEn: $nameEn, scientificName: $scientificName, form: $form, strength: $strength, unit: $unit, officialPriceEgp: $officialPriceEgp, requiresPrescription: $requiresPrescription, available: $available)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrugResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.scientificName, scientificName) ||
                other.scientificName == scientificName) &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.strength, strength) ||
                other.strength == strength) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.officialPriceEgp, officialPriceEgp) ||
                other.officialPriceEgp == officialPriceEgp) &&
            (identical(other.requiresPrescription, requiresPrescription) ||
                other.requiresPrescription == requiresPrescription) &&
            (identical(other.available, available) ||
                other.available == available));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nameAr,
      nameEn,
      scientificName,
      form,
      strength,
      unit,
      officialPriceEgp,
      requiresPrescription,
      available);

  /// Create a copy of DrugResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DrugResultImplCopyWith<_$DrugResultImpl> get copyWith =>
      __$$DrugResultImplCopyWithImpl<_$DrugResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DrugResultImplToJson(
      this,
    );
  }
}

abstract class _DrugResult implements DrugResult {
  const factory _DrugResult(
      {required final int id,
      @JsonKey(name: 'name_ar') required final String nameAr,
      @JsonKey(name: 'name_en') required final String nameEn,
      @JsonKey(name: 'scientific_name') final String? scientificName,
      final String? form,
      final String? strength,
      final String? unit,
      @JsonKey(name: 'official_price_egp', fromJson: _parseDouble)
      final double? officialPriceEgp,
      @JsonKey(name: 'requires_prescription') final bool requiresPrescription,
      final bool available}) = _$DrugResultImpl;

  factory _DrugResult.fromJson(Map<String, dynamic> json) =
      _$DrugResultImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'name_ar')
  String get nameAr;
  @override
  @JsonKey(name: 'name_en')
  String get nameEn;
  @override
  @JsonKey(name: 'scientific_name')
  String? get scientificName;
  @override
  String? get form;
  @override
  String? get strength;
  @override
  String? get unit;
  @override
  @JsonKey(name: 'official_price_egp', fromJson: _parseDouble)
  double? get officialPriceEgp;
  @override
  @JsonKey(name: 'requires_prescription')
  bool get requiresPrescription;
  @override
  bool get available;

  /// Create a copy of DrugResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DrugResultImplCopyWith<_$DrugResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
