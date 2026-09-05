// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forgot_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ForgotPasswordState {

 ForgotPasswordStatus get status; bool get isPhoneValid; bool get isCodeValid; bool get isNewPasswordValid; bool get showNewPassword; bool get showConfirmPassword; String? get message; String? get error;
/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForgotPasswordStateCopyWith<ForgotPasswordState> get copyWith => _$ForgotPasswordStateCopyWithImpl<ForgotPasswordState>(this as ForgotPasswordState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ForgotPasswordState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForgotPasswordState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.isPhoneValid, _this.isPhoneValid) || other.isPhoneValid == _this.isPhoneValid)&&(identical(other.isCodeValid, _this.isCodeValid) || other.isCodeValid == _this.isCodeValid)&&(identical(other.isNewPasswordValid, _this.isNewPasswordValid) || other.isNewPasswordValid == _this.isNewPasswordValid)&&(identical(other.showNewPassword, _this.showNewPassword) || other.showNewPassword == _this.showNewPassword)&&(identical(other.showConfirmPassword, _this.showConfirmPassword) || other.showConfirmPassword == _this.showConfirmPassword)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as ForgotPasswordState;
  return Object.hash(runtimeType,_this.status,_this.isPhoneValid,_this.isCodeValid,_this.isNewPasswordValid,_this.showNewPassword,_this.showConfirmPassword,_this.message,_this.error);
}

@override
String toString() {
  final _this = this as ForgotPasswordState;
  return 'ForgotPasswordState(status: ${_this.status}, isPhoneValid: ${_this.isPhoneValid}, isCodeValid: ${_this.isCodeValid}, isNewPasswordValid: ${_this.isNewPasswordValid}, showNewPassword: ${_this.showNewPassword}, showConfirmPassword: ${_this.showConfirmPassword}, message: ${_this.message}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $ForgotPasswordStateCopyWith<$Res>  {
  factory $ForgotPasswordStateCopyWith(ForgotPasswordState value, $Res Function(ForgotPasswordState) _then) = _$ForgotPasswordStateCopyWithImpl;
@useResult
$Res call({
 ForgotPasswordStatus status, bool isPhoneValid, bool isCodeValid, bool isNewPasswordValid, bool showNewPassword, bool showConfirmPassword, String? message, String? error
});




}
/// @nodoc
class _$ForgotPasswordStateCopyWithImpl<$Res>
    implements $ForgotPasswordStateCopyWith<$Res> {
  _$ForgotPasswordStateCopyWithImpl(this._self, this._then);

  final ForgotPasswordState _self;
  final $Res Function(ForgotPasswordState) _then;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? isPhoneValid = null,Object? isCodeValid = null,Object? isNewPasswordValid = null,Object? showNewPassword = null,Object? showConfirmPassword = null,Object? message = freezed,Object? error = freezed,}) {
  return _then(ForgotPasswordState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ForgotPasswordStatus,isPhoneValid: null == isPhoneValid ? _self.isPhoneValid : isPhoneValid // ignore: cast_nullable_to_non_nullable
as bool,isCodeValid: null == isCodeValid ? _self.isCodeValid : isCodeValid // ignore: cast_nullable_to_non_nullable
as bool,isNewPasswordValid: null == isNewPasswordValid ? _self.isNewPasswordValid : isNewPasswordValid // ignore: cast_nullable_to_non_nullable
as bool,showNewPassword: null == showNewPassword ? _self.showNewPassword : showNewPassword // ignore: cast_nullable_to_non_nullable
as bool,showConfirmPassword: null == showConfirmPassword ? _self.showConfirmPassword : showConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ForgotPasswordState].
extension ForgotPasswordStatePatterns on ForgotPasswordState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForgotPasswordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForgotPasswordState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForgotPasswordState value)  $default,){
final _that = this;
switch (_that) {
case _ForgotPasswordState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForgotPasswordState value)?  $default,){
final _that = this;
switch (_that) {
case _ForgotPasswordState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ForgotPasswordStatus status,  bool isPhoneValid,  bool isCodeValid,  bool isNewPasswordValid,  bool showNewPassword,  bool showConfirmPassword,  String? message,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForgotPasswordState() when $default != null:
return $default(_that.status,_that.isPhoneValid,_that.isCodeValid,_that.isNewPasswordValid,_that.showNewPassword,_that.showConfirmPassword,_that.message,_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ForgotPasswordStatus status,  bool isPhoneValid,  bool isCodeValid,  bool isNewPasswordValid,  bool showNewPassword,  bool showConfirmPassword,  String? message,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ForgotPasswordState():
return $default(_that.status,_that.isPhoneValid,_that.isCodeValid,_that.isNewPasswordValid,_that.showNewPassword,_that.showConfirmPassword,_that.message,_that.error);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ForgotPasswordStatus status,  bool isPhoneValid,  bool isCodeValid,  bool isNewPasswordValid,  bool showNewPassword,  bool showConfirmPassword,  String? message,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ForgotPasswordState() when $default != null:
return $default(_that.status,_that.isPhoneValid,_that.isCodeValid,_that.isNewPasswordValid,_that.showNewPassword,_that.showConfirmPassword,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ForgotPasswordState implements ForgotPasswordState {
  const _ForgotPasswordState({this.status = ForgotPasswordStatus.initial, this.isPhoneValid = false, this.isCodeValid = false, this.isNewPasswordValid = false, this.showNewPassword = true, this.showConfirmPassword = true, this.message, this.error});
  

@override@JsonKey() final  ForgotPasswordStatus status;
@override@JsonKey() final  bool isPhoneValid;
@override@JsonKey() final  bool isCodeValid;
@override@JsonKey() final  bool isNewPasswordValid;
@override@JsonKey() final  bool showNewPassword;
@override@JsonKey() final  bool showConfirmPassword;
@override final  String? message;
@override final  String? error;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForgotPasswordStateCopyWith<_ForgotPasswordState> get copyWith => __$ForgotPasswordStateCopyWithImpl<_ForgotPasswordState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForgotPasswordState&&(identical(other.status, status) || other.status == status)&&(identical(other.isPhoneValid, isPhoneValid) || other.isPhoneValid == isPhoneValid)&&(identical(other.isCodeValid, isCodeValid) || other.isCodeValid == isCodeValid)&&(identical(other.isNewPasswordValid, isNewPasswordValid) || other.isNewPasswordValid == isNewPasswordValid)&&(identical(other.showNewPassword, showNewPassword) || other.showNewPassword == showNewPassword)&&(identical(other.showConfirmPassword, showConfirmPassword) || other.showConfirmPassword == showConfirmPassword)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,isPhoneValid,isCodeValid,isNewPasswordValid,showNewPassword,showConfirmPassword,message,error);
}

@override
String toString() {
    return 'ForgotPasswordState(status: $status, isPhoneValid: $isPhoneValid, isCodeValid: $isCodeValid, isNewPasswordValid: $isNewPasswordValid, showNewPassword: $showNewPassword, showConfirmPassword: $showConfirmPassword, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ForgotPasswordStateCopyWith<$Res> implements $ForgotPasswordStateCopyWith<$Res> {
  factory _$ForgotPasswordStateCopyWith(_ForgotPasswordState value, $Res Function(_ForgotPasswordState) _then) = __$ForgotPasswordStateCopyWithImpl;
@override @useResult
$Res call({
 ForgotPasswordStatus status, bool isPhoneValid, bool isCodeValid, bool isNewPasswordValid, bool showNewPassword, bool showConfirmPassword, String? message, String? error
});




}
/// @nodoc
class __$ForgotPasswordStateCopyWithImpl<$Res>
    implements _$ForgotPasswordStateCopyWith<$Res> {
  __$ForgotPasswordStateCopyWithImpl(this._self, this._then);

  final _ForgotPasswordState _self;
  final $Res Function(_ForgotPasswordState) _then;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? isPhoneValid = null,Object? isCodeValid = null,Object? isNewPasswordValid = null,Object? showNewPassword = null,Object? showConfirmPassword = null,Object? message = freezed,Object? error = freezed,}) {
  return _then(_ForgotPasswordState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ForgotPasswordStatus,isPhoneValid: null == isPhoneValid ? _self.isPhoneValid : isPhoneValid // ignore: cast_nullable_to_non_nullable
as bool,isCodeValid: null == isCodeValid ? _self.isCodeValid : isCodeValid // ignore: cast_nullable_to_non_nullable
as bool,isNewPasswordValid: null == isNewPasswordValid ? _self.isNewPasswordValid : isNewPasswordValid // ignore: cast_nullable_to_non_nullable
as bool,showNewPassword: null == showNewPassword ? _self.showNewPassword : showNewPassword // ignore: cast_nullable_to_non_nullable
as bool,showConfirmPassword: null == showConfirmPassword ? _self.showConfirmPassword : showConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
