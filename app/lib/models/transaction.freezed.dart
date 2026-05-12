// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Transaction {

 String get transactionId;@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime get date; String get description; String get sourceModule;// GL, AR, AP, INV, FA
 bool get isPosted; int get totalAmount;// total debit dalam sen (denormalisasi untuk performa list)
 String get createdBy;// userId — audit trail
 String? get deviceId;// audit trail
 String? get reversalOfId;
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCopyWith<Transaction> get copyWith => _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transaction&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.date, date) || other.date == date)&&(identical(other.description, description) || other.description == description)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.isPosted, isPosted) || other.isPosted == isPosted)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.reversalOfId, reversalOfId) || other.reversalOfId == reversalOfId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transactionId,date,description,sourceModule,isPosted,totalAmount,createdBy,deviceId,reversalOfId);

@override
String toString() {
  return 'Transaction(transactionId: $transactionId, date: $date, description: $description, sourceModule: $sourceModule, isPosted: $isPosted, totalAmount: $totalAmount, createdBy: $createdBy, deviceId: $deviceId, reversalOfId: $reversalOfId)';
}


}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res>  {
  factory $TransactionCopyWith(Transaction value, $Res Function(Transaction) _then) = _$TransactionCopyWithImpl;
@useResult
$Res call({
 String transactionId,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime date, String description, String sourceModule, bool isPosted, int totalAmount, String createdBy, String? deviceId, String? reversalOfId
});




}
/// @nodoc
class _$TransactionCopyWithImpl<$Res>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactionId = null,Object? date = null,Object? description = null,Object? sourceModule = null,Object? isPosted = null,Object? totalAmount = null,Object? createdBy = null,Object? deviceId = freezed,Object? reversalOfId = freezed,}) {
  return _then(_self.copyWith(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,isPosted: null == isPosted ? _self.isPosted : isPosted // ignore: cast_nullable_to_non_nullable
as bool,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,reversalOfId: freezed == reversalOfId ? _self.reversalOfId : reversalOfId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transaction value)  $default,){
final _that = this;
switch (_that) {
case _Transaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transaction value)?  $default,){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String transactionId, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime date,  String description,  String sourceModule,  bool isPosted,  int totalAmount,  String createdBy,  String? deviceId,  String? reversalOfId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.transactionId,_that.date,_that.description,_that.sourceModule,_that.isPosted,_that.totalAmount,_that.createdBy,_that.deviceId,_that.reversalOfId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String transactionId, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime date,  String description,  String sourceModule,  bool isPosted,  int totalAmount,  String createdBy,  String? deviceId,  String? reversalOfId)  $default,) {final _that = this;
switch (_that) {
case _Transaction():
return $default(_that.transactionId,_that.date,_that.description,_that.sourceModule,_that.isPosted,_that.totalAmount,_that.createdBy,_that.deviceId,_that.reversalOfId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String transactionId, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)  DateTime date,  String description,  String sourceModule,  bool isPosted,  int totalAmount,  String createdBy,  String? deviceId,  String? reversalOfId)?  $default,) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.transactionId,_that.date,_that.description,_that.sourceModule,_that.isPosted,_that.totalAmount,_that.createdBy,_that.deviceId,_that.reversalOfId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Transaction implements Transaction {
  const _Transaction({required this.transactionId, @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) required this.date, required this.description, required this.sourceModule, this.isPosted = false, this.totalAmount = 0, required this.createdBy, this.deviceId, this.reversalOfId});
  factory _Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

@override final  String transactionId;
@override@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) final  DateTime date;
@override final  String description;
@override final  String sourceModule;
// GL, AR, AP, INV, FA
@override@JsonKey() final  bool isPosted;
@override@JsonKey() final  int totalAmount;
// total debit dalam sen (denormalisasi untuk performa list)
@override final  String createdBy;
// userId — audit trail
@override final  String? deviceId;
// audit trail
@override final  String? reversalOfId;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCopyWith<_Transaction> get copyWith => __$TransactionCopyWithImpl<_Transaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transaction&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.date, date) || other.date == date)&&(identical(other.description, description) || other.description == description)&&(identical(other.sourceModule, sourceModule) || other.sourceModule == sourceModule)&&(identical(other.isPosted, isPosted) || other.isPosted == isPosted)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.reversalOfId, reversalOfId) || other.reversalOfId == reversalOfId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,transactionId,date,description,sourceModule,isPosted,totalAmount,createdBy,deviceId,reversalOfId);

@override
String toString() {
  return 'Transaction(transactionId: $transactionId, date: $date, description: $description, sourceModule: $sourceModule, isPosted: $isPosted, totalAmount: $totalAmount, createdBy: $createdBy, deviceId: $deviceId, reversalOfId: $reversalOfId)';
}


}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res> implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(_Transaction value, $Res Function(_Transaction) _then) = __$TransactionCopyWithImpl;
@override @useResult
$Res call({
 String transactionId,@JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson) DateTime date, String description, String sourceModule, bool isPosted, int totalAmount, String createdBy, String? deviceId, String? reversalOfId
});




}
/// @nodoc
class __$TransactionCopyWithImpl<$Res>
    implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactionId = null,Object? date = null,Object? description = null,Object? sourceModule = null,Object? isPosted = null,Object? totalAmount = null,Object? createdBy = null,Object? deviceId = freezed,Object? reversalOfId = freezed,}) {
  return _then(_Transaction(
transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sourceModule: null == sourceModule ? _self.sourceModule : sourceModule // ignore: cast_nullable_to_non_nullable
as String,isPosted: null == isPosted ? _self.isPosted : isPosted // ignore: cast_nullable_to_non_nullable
as bool,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,reversalOfId: freezed == reversalOfId ? _self.reversalOfId : reversalOfId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
