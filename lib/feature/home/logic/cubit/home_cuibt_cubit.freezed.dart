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

 RequestStatus get bannersStatus; List<BannerEntity> get banners; int get bannerIndex; String? get bannersError; RequestStatus get categoriesStatus; List<CategoryEntity> get categories; String get selectedCategory; String? get categoriesError;
/// Create a copy of HomeCuibtState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeCuibtStateCopyWith<HomeCuibtState> get copyWith => _$HomeCuibtStateCopyWithImpl<HomeCuibtState>(this as HomeCuibtState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HomeCuibtState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeCuibtState&&(identical(other.bannersStatus, _this.bannersStatus) || other.bannersStatus == _this.bannersStatus)&&const DeepCollectionEquality().equals(other.banners, _this.banners)&&(identical(other.bannerIndex, _this.bannerIndex) || other.bannerIndex == _this.bannerIndex)&&(identical(other.bannersError, _this.bannersError) || other.bannersError == _this.bannersError)&&(identical(other.categoriesStatus, _this.categoriesStatus) || other.categoriesStatus == _this.categoriesStatus)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&(identical(other.selectedCategory, _this.selectedCategory) || other.selectedCategory == _this.selectedCategory)&&(identical(other.categoriesError, _this.categoriesError) || other.categoriesError == _this.categoriesError));
}


@override
int get hashCode {
  final _this = this as HomeCuibtState;
  return Object.hash(runtimeType,_this.bannersStatus,const DeepCollectionEquality().hash(_this.banners),_this.bannerIndex,_this.bannersError,_this.categoriesStatus,const DeepCollectionEquality().hash(_this.categories),_this.selectedCategory,_this.categoriesError);
}

@override
String toString() {
  final _this = this as HomeCuibtState;
  return 'HomeCuibtState(bannersStatus: ${_this.bannersStatus}, banners: ${_this.banners}, bannerIndex: ${_this.bannerIndex}, bannersError: ${_this.bannersError}, categoriesStatus: ${_this.categoriesStatus}, categories: ${_this.categories}, selectedCategory: ${_this.selectedCategory}, categoriesError: ${_this.categoriesError})';
}


}

/// @nodoc
abstract mixin class $HomeCuibtStateCopyWith<$Res>  {
  factory $HomeCuibtStateCopyWith(HomeCuibtState value, $Res Function(HomeCuibtState) _then) = _$HomeCuibtStateCopyWithImpl;
@useResult
$Res call({
 RequestStatus bannersStatus, List<BannerEntity> banners, int bannerIndex, String? bannersError, RequestStatus categoriesStatus, List<CategoryEntity> categories, String selectedCategory, String? categoriesError
});




}
/// @nodoc
class _$HomeCuibtStateCopyWithImpl<$Res>
    implements $HomeCuibtStateCopyWith<$Res> {
  _$HomeCuibtStateCopyWithImpl(this._self, this._then);

  final HomeCuibtState _self;
  final $Res Function(HomeCuibtState) _then;

/// Create a copy of HomeCuibtState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bannersStatus = null,Object? banners = null,Object? bannerIndex = null,Object? bannersError = freezed,Object? categoriesStatus = null,Object? categories = null,Object? selectedCategory = null,Object? categoriesError = freezed,}) {
  return _then(HomeCuibtState(
bannersStatus: null == bannersStatus ? _self.bannersStatus : bannersStatus // ignore: cast_nullable_to_non_nullable
as RequestStatus,banners: null == banners ? _self.banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerEntity>,bannerIndex: null == bannerIndex ? _self.bannerIndex : bannerIndex // ignore: cast_nullable_to_non_nullable
as int,bannersError: freezed == bannersError ? _self.bannersError : bannersError // ignore: cast_nullable_to_non_nullable
as String?,categoriesStatus: null == categoriesStatus ? _self.categoriesStatus : categoriesStatus // ignore: cast_nullable_to_non_nullable
as RequestStatus,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryEntity>,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String,categoriesError: freezed == categoriesError ? _self.categoriesError : categoriesError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeCuibtState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeCuibtState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeCuibtState value)  $default,){
final _that = this;
switch (_that) {
case _HomeCuibtState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeCuibtState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeCuibtState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RequestStatus bannersStatus,  List<BannerEntity> banners,  int bannerIndex,  String? bannersError,  RequestStatus categoriesStatus,  List<CategoryEntity> categories,  String selectedCategory,  String? categoriesError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeCuibtState() when $default != null:
return $default(_that.bannersStatus,_that.banners,_that.bannerIndex,_that.bannersError,_that.categoriesStatus,_that.categories,_that.selectedCategory,_that.categoriesError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RequestStatus bannersStatus,  List<BannerEntity> banners,  int bannerIndex,  String? bannersError,  RequestStatus categoriesStatus,  List<CategoryEntity> categories,  String selectedCategory,  String? categoriesError)  $default,) {final _that = this;
switch (_that) {
case _HomeCuibtState():
return $default(_that.bannersStatus,_that.banners,_that.bannerIndex,_that.bannersError,_that.categoriesStatus,_that.categories,_that.selectedCategory,_that.categoriesError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RequestStatus bannersStatus,  List<BannerEntity> banners,  int bannerIndex,  String? bannersError,  RequestStatus categoriesStatus,  List<CategoryEntity> categories,  String selectedCategory,  String? categoriesError)?  $default,) {final _that = this;
switch (_that) {
case _HomeCuibtState() when $default != null:
return $default(_that.bannersStatus,_that.banners,_that.bannerIndex,_that.bannersError,_that.categoriesStatus,_that.categories,_that.selectedCategory,_that.categoriesError);case _:
  return null;

}
}

}

/// @nodoc


class _HomeCuibtState implements HomeCuibtState {
  const _HomeCuibtState({this.bannersStatus = RequestStatus.initial,  List<BannerEntity> banners = const [], this.bannerIndex = 0, this.bannersError, this.categoriesStatus = RequestStatus.initial,  List<CategoryEntity> categories = const [], this.selectedCategory = 'علف ارانب', this.categoriesError}): _banners = banners,_categories = categories;
  

@override@JsonKey() final  RequestStatus bannersStatus;
 final  List<BannerEntity> _banners;
@override@JsonKey() List<BannerEntity> get banners {
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_banners);
}

@override@JsonKey() final  int bannerIndex;
@override final  String? bannersError;
@override@JsonKey() final  RequestStatus categoriesStatus;
 final  List<CategoryEntity> _categories;
@override@JsonKey() List<CategoryEntity> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey() final  String selectedCategory;
@override final  String? categoriesError;

/// Create a copy of HomeCuibtState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeCuibtStateCopyWith<_HomeCuibtState> get copyWith => __$HomeCuibtStateCopyWithImpl<_HomeCuibtState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeCuibtState&&(identical(other.bannersStatus, bannersStatus) || other.bannersStatus == bannersStatus)&&const DeepCollectionEquality().equals(other.banners, _banners)&&(identical(other.bannerIndex, bannerIndex) || other.bannerIndex == bannerIndex)&&(identical(other.bannersError, bannersError) || other.bannersError == bannersError)&&(identical(other.categoriesStatus, categoriesStatus) || other.categoriesStatus == categoriesStatus)&&const DeepCollectionEquality().equals(other.categories, _categories)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&(identical(other.categoriesError, categoriesError) || other.categoriesError == categoriesError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,bannersStatus,const DeepCollectionEquality().hash(_banners),bannerIndex,bannersError,categoriesStatus,const DeepCollectionEquality().hash(_categories),selectedCategory,categoriesError);
}

@override
String toString() {
    return 'HomeCuibtState(bannersStatus: $bannersStatus, banners: $banners, bannerIndex: $bannerIndex, bannersError: $bannersError, categoriesStatus: $categoriesStatus, categories: $categories, selectedCategory: $selectedCategory, categoriesError: $categoriesError)';
}


}

/// @nodoc
abstract mixin class _$HomeCuibtStateCopyWith<$Res> implements $HomeCuibtStateCopyWith<$Res> {
  factory _$HomeCuibtStateCopyWith(_HomeCuibtState value, $Res Function(_HomeCuibtState) _then) = __$HomeCuibtStateCopyWithImpl;
@override @useResult
$Res call({
 RequestStatus bannersStatus, List<BannerEntity> banners, int bannerIndex, String? bannersError, RequestStatus categoriesStatus, List<CategoryEntity> categories, String selectedCategory, String? categoriesError
});




}
/// @nodoc
class __$HomeCuibtStateCopyWithImpl<$Res>
    implements _$HomeCuibtStateCopyWith<$Res> {
  __$HomeCuibtStateCopyWithImpl(this._self, this._then);

  final _HomeCuibtState _self;
  final $Res Function(_HomeCuibtState) _then;

/// Create a copy of HomeCuibtState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bannersStatus = null,Object? banners = null,Object? bannerIndex = null,Object? bannersError = freezed,Object? categoriesStatus = null,Object? categories = null,Object? selectedCategory = null,Object? categoriesError = freezed,}) {
  return _then(_HomeCuibtState(
bannersStatus: null == bannersStatus ? _self.bannersStatus : bannersStatus // ignore: cast_nullable_to_non_nullable
as RequestStatus,banners: null == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerEntity>,bannerIndex: null == bannerIndex ? _self.bannerIndex : bannerIndex // ignore: cast_nullable_to_non_nullable
as int,bannersError: freezed == bannersError ? _self.bannersError : bannersError // ignore: cast_nullable_to_non_nullable
as String?,categoriesStatus: null == categoriesStatus ? _self.categoriesStatus : categoriesStatus // ignore: cast_nullable_to_non_nullable
as RequestStatus,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryEntity>,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String,categoriesError: freezed == categoriesError ? _self.categoriesError : categoriesError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
