// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_cuibt_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeCuibtState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeCuibtState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HomeCuibtState()';
}


}

/// @nodoc
class $HomeCuibtStateCopyWith<$Res>  {
$HomeCuibtStateCopyWith(HomeCuibtState _, $Res Function(HomeCuibtState) __);
}


/// Adds pattern-matching-related methods to [HomeCuibtState].
extension HomeCuibtStatePatterns on HomeCuibtState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( GetBannersLoading value)?  getBannersLoading,TResult Function( GetBannersSuccess value)?  getBannersSuccess,TResult Function( GetBannersError value)?  getBannersError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case GetBannersLoading() when getBannersLoading != null:
return getBannersLoading(_that);case GetBannersSuccess() when getBannersSuccess != null:
return getBannersSuccess(_that);case GetBannersError() when getBannersError != null:
return getBannersError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( GetBannersLoading value)  getBannersLoading,required TResult Function( GetBannersSuccess value)  getBannersSuccess,required TResult Function( GetBannersError value)  getBannersError,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case GetBannersLoading():
return getBannersLoading(_that);case GetBannersSuccess():
return getBannersSuccess(_that);case GetBannersError():
return getBannersError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( GetBannersLoading value)?  getBannersLoading,TResult? Function( GetBannersSuccess value)?  getBannersSuccess,TResult? Function( GetBannersError value)?  getBannersError,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case GetBannersLoading() when getBannersLoading != null:
return getBannersLoading(_that);case GetBannersSuccess() when getBannersSuccess != null:
return getBannersSuccess(_that);case GetBannersError() when getBannersError != null:
return getBannersError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  getBannersLoading,TResult Function( List<BannerEntity> banners,  int bannerIndex)?  getBannersSuccess,TResult Function( String error)?  getBannersError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case GetBannersLoading() when getBannersLoading != null:
return getBannersLoading();case GetBannersSuccess() when getBannersSuccess != null:
return getBannersSuccess(_that.banners,_that.bannerIndex);case GetBannersError() when getBannersError != null:
return getBannersError(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  getBannersLoading,required TResult Function( List<BannerEntity> banners,  int bannerIndex)  getBannersSuccess,required TResult Function( String error)  getBannersError,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case GetBannersLoading():
return getBannersLoading();case GetBannersSuccess():
return getBannersSuccess(_that.banners,_that.bannerIndex);case GetBannersError():
return getBannersError(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  getBannersLoading,TResult? Function( List<BannerEntity> banners,  int bannerIndex)?  getBannersSuccess,TResult? Function( String error)?  getBannersError,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case GetBannersLoading() when getBannersLoading != null:
return getBannersLoading();case GetBannersSuccess() when getBannersSuccess != null:
return getBannersSuccess(_that.banners,_that.bannerIndex);case GetBannersError() when getBannersError != null:
return getBannersError(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements HomeCuibtState {
  const _Initial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HomeCuibtState.initial()';
}


}




/// @nodoc


class GetBannersLoading implements HomeCuibtState {
  const GetBannersLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is GetBannersLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'HomeCuibtState.getBannersLoading()';
}


}




/// @nodoc


class GetBannersSuccess implements HomeCuibtState {
  const GetBannersSuccess( List<BannerEntity> banners, {this.bannerIndex = 0}): _banners = banners;
  

 final  List<BannerEntity> _banners;
 List<BannerEntity> get banners {
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_banners);
}

@JsonKey() final  int bannerIndex;

/// Create a copy of HomeCuibtState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetBannersSuccessCopyWith<GetBannersSuccess> get copyWith => _$GetBannersSuccessCopyWithImpl<GetBannersSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is GetBannersSuccess&&const DeepCollectionEquality().equals(other.banners, _banners)&&(identical(other.bannerIndex, bannerIndex) || other.bannerIndex == bannerIndex));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_banners),bannerIndex);
}

@override
String toString() {
    return 'HomeCuibtState.getBannersSuccess(banners: $banners, bannerIndex: $bannerIndex)';
}


}

/// @nodoc
abstract mixin class $GetBannersSuccessCopyWith<$Res> implements $HomeCuibtStateCopyWith<$Res> {
  factory $GetBannersSuccessCopyWith(GetBannersSuccess value, $Res Function(GetBannersSuccess) _then) = _$GetBannersSuccessCopyWithImpl;
@useResult
$Res call({
 List<BannerEntity> banners, int bannerIndex
});




}
/// @nodoc
class _$GetBannersSuccessCopyWithImpl<$Res>
    implements $GetBannersSuccessCopyWith<$Res> {
  _$GetBannersSuccessCopyWithImpl(this._self, this._then);

  final GetBannersSuccess _self;
  final $Res Function(GetBannersSuccess) _then;

/// Create a copy of HomeCuibtState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? banners = null,Object? bannerIndex = null,}) {
  return _then(GetBannersSuccess(
null == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerEntity>,bannerIndex: null == bannerIndex ? _self.bannerIndex : bannerIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class GetBannersError implements HomeCuibtState {
  const GetBannersError(this.error);
  

 final  String error;

/// Create a copy of HomeCuibtState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetBannersErrorCopyWith<GetBannersError> get copyWith => _$GetBannersErrorCopyWithImpl<GetBannersError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is GetBannersError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,error);
}

@override
String toString() {
    return 'HomeCuibtState.getBannersError(error: $error)';
}


}

/// @nodoc
abstract mixin class $GetBannersErrorCopyWith<$Res> implements $HomeCuibtStateCopyWith<$Res> {
  factory $GetBannersErrorCopyWith(GetBannersError value, $Res Function(GetBannersError) _then) = _$GetBannersErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$GetBannersErrorCopyWithImpl<$Res>
    implements $GetBannersErrorCopyWith<$Res> {
  _$GetBannersErrorCopyWithImpl(this._self, this._then);

  final GetBannersError _self;
  final $Res Function(GetBannersError) _then;

/// Create a copy of HomeCuibtState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(GetBannersError(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
