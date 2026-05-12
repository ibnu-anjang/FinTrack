// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountGroup {

 String get id; String get name; AccountCategory get accountType;// tipe akuntansi (asset/liability/dll)
 int get order;
/// Create a copy of AccountGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountGroupCopyWith<AccountGroup> get copyWith => _$AccountGroupCopyWithImpl<AccountGroup>(this as AccountGroup, _$identity);

  /// Serializes this AccountGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,accountType,order);

@override
String toString() {
  return 'AccountGroup(id: $id, name: $name, accountType: $accountType, order: $order)';
}


}

/// @nodoc
abstract mixin class $AccountGroupCopyWith<$Res>  {
  factory $AccountGroupCopyWith(AccountGroup value, $Res Function(AccountGroup) _then) = _$AccountGroupCopyWithImpl;
@useResult
$Res call({
 String id, String name, AccountCategory accountType, int order
});




}
/// @nodoc
class _$AccountGroupCopyWithImpl<$Res>
    implements $AccountGroupCopyWith<$Res> {
  _$AccountGroupCopyWithImpl(this._self, this._then);

  final AccountGroup _self;
  final $Res Function(AccountGroup) _then;

/// Create a copy of AccountGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? accountType = null,Object? order = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as AccountCategory,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountGroup].
extension AccountGroupPatterns on AccountGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountGroup value)  $default,){
final _that = this;
switch (_that) {
case _AccountGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountGroup value)?  $default,){
final _that = this;
switch (_that) {
case _AccountGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  AccountCategory accountType,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountGroup() when $default != null:
return $default(_that.id,_that.name,_that.accountType,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  AccountCategory accountType,  int order)  $default,) {final _that = this;
switch (_that) {
case _AccountGroup():
return $default(_that.id,_that.name,_that.accountType,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  AccountCategory accountType,  int order)?  $default,) {final _that = this;
switch (_that) {
case _AccountGroup() when $default != null:
return $default(_that.id,_that.name,_that.accountType,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountGroup implements AccountGroup {
  const _AccountGroup({required this.id, required this.name, required this.accountType, this.order = 0});
  factory _AccountGroup.fromJson(Map<String, dynamic> json) => _$AccountGroupFromJson(json);

@override final  String id;
@override final  String name;
@override final  AccountCategory accountType;
// tipe akuntansi (asset/liability/dll)
@override@JsonKey() final  int order;

/// Create a copy of AccountGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountGroupCopyWith<_AccountGroup> get copyWith => __$AccountGroupCopyWithImpl<_AccountGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,accountType,order);

@override
String toString() {
  return 'AccountGroup(id: $id, name: $name, accountType: $accountType, order: $order)';
}


}

/// @nodoc
abstract mixin class _$AccountGroupCopyWith<$Res> implements $AccountGroupCopyWith<$Res> {
  factory _$AccountGroupCopyWith(_AccountGroup value, $Res Function(_AccountGroup) _then) = __$AccountGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, AccountCategory accountType, int order
});




}
/// @nodoc
class __$AccountGroupCopyWithImpl<$Res>
    implements _$AccountGroupCopyWith<$Res> {
  __$AccountGroupCopyWithImpl(this._self, this._then);

  final _AccountGroup _self;
  final $Res Function(_AccountGroup) _then;

/// Create a copy of AccountGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? accountType = null,Object? order = null,}) {
  return _then(_AccountGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as AccountCategory,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
