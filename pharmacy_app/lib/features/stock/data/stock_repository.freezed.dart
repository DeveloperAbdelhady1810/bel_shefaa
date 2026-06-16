// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DrugLookupResult _$DrugLookupResultFromJson(Map<String, dynamic> json) {
  return _DrugLookupResult.fromJson(json);
}

/// @nodoc
mixin _$DrugLookupResult {
  int get drugId => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String? get nameEn => throw _privateConstructorUsedError;
  String? get form => throw _privateConstructorUsedError;
  String? get strength => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this DrugLookupResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DrugLookupResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DrugLookupResultCopyWith<DrugLookupResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DrugLookupResultCopyWith<$Res> {
  factory $DrugLookupResultCopyWith(
          DrugLookupResult value, $Res Function(DrugLookupResult) then) =
      _$DrugLookupResultCopyWithImpl<$Res, DrugLookupResult>;
  @useResult
  $Res call(
      {int drugId,
      String nameAr,
      String? nameEn,
      String? form,
      String? strength,
      int quantity});
}

/// @nodoc
class _$DrugLookupResultCopyWithImpl<$Res, $Val extends DrugLookupResult>
    implements $DrugLookupResultCopyWith<$Res> {
  _$DrugLookupResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DrugLookupResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drugId = null,
    Object? nameAr = null,
    Object? nameEn = freezed,
    Object? form = freezed,
    Object? strength = freezed,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      drugId: null == drugId
          ? _value.drugId
          : drugId // ignore: cast_nullable_to_non_nullable
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
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DrugLookupResultImplCopyWith<$Res>
    implements $DrugLookupResultCopyWith<$Res> {
  factory _$$DrugLookupResultImplCopyWith(_$DrugLookupResultImpl value,
          $Res Function(_$DrugLookupResultImpl) then) =
      __$$DrugLookupResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int drugId,
      String nameAr,
      String? nameEn,
      String? form,
      String? strength,
      int quantity});
}

/// @nodoc
class __$$DrugLookupResultImplCopyWithImpl<$Res>
    extends _$DrugLookupResultCopyWithImpl<$Res, _$DrugLookupResultImpl>
    implements _$$DrugLookupResultImplCopyWith<$Res> {
  __$$DrugLookupResultImplCopyWithImpl(_$DrugLookupResultImpl _value,
      $Res Function(_$DrugLookupResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of DrugLookupResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drugId = null,
    Object? nameAr = null,
    Object? nameEn = freezed,
    Object? form = freezed,
    Object? strength = freezed,
    Object? quantity = null,
  }) {
    return _then(_$DrugLookupResultImpl(
      drugId: null == drugId
          ? _value.drugId
          : drugId // ignore: cast_nullable_to_non_nullable
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
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DrugLookupResultImpl implements _DrugLookupResult {
  const _$DrugLookupResultImpl(
      {required this.drugId,
      required this.nameAr,
      this.nameEn,
      this.form,
      this.strength,
      required this.quantity});

  factory _$DrugLookupResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$DrugLookupResultImplFromJson(json);

  @override
  final int drugId;
  @override
  final String nameAr;
  @override
  final String? nameEn;
  @override
  final String? form;
  @override
  final String? strength;
  @override
  final int quantity;

  @override
  String toString() {
    return 'DrugLookupResult(drugId: $drugId, nameAr: $nameAr, nameEn: $nameEn, form: $form, strength: $strength, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrugLookupResultImpl &&
            (identical(other.drugId, drugId) || other.drugId == drugId) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.form, form) || other.form == form) &&
            (identical(other.strength, strength) ||
                other.strength == strength) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, drugId, nameAr, nameEn, form, strength, quantity);

  /// Create a copy of DrugLookupResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DrugLookupResultImplCopyWith<_$DrugLookupResultImpl> get copyWith =>
      __$$DrugLookupResultImplCopyWithImpl<_$DrugLookupResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DrugLookupResultImplToJson(
      this,
    );
  }
}

abstract class _DrugLookupResult implements DrugLookupResult {
  const factory _DrugLookupResult(
      {required final int drugId,
      required final String nameAr,
      final String? nameEn,
      final String? form,
      final String? strength,
      required final int quantity}) = _$DrugLookupResultImpl;

  factory _DrugLookupResult.fromJson(Map<String, dynamic> json) =
      _$DrugLookupResultImpl.fromJson;

  @override
  int get drugId;
  @override
  String get nameAr;
  @override
  String? get nameEn;
  @override
  String? get form;
  @override
  String? get strength;
  @override
  int get quantity;

  /// Create a copy of DrugLookupResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DrugLookupResultImplCopyWith<_$DrugLookupResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
