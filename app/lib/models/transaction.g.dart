// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
  transactionId: json['transactionId'] as String,
  date: _timestampFromJson(json['date']),
  description: json['description'] as String,
  sourceModule: json['sourceModule'] as String,
  isPosted: json['isPosted'] as bool? ?? false,
  totalAmount: (json['totalAmount'] as num?)?.toInt() ?? 0,
  createdBy: json['createdBy'] as String,
  deviceId: json['deviceId'] as String?,
  reversalOfId: json['reversalOfId'] as String?,
);

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'date': _timestampToJson(instance.date),
      'description': instance.description,
      'sourceModule': instance.sourceModule,
      'isPosted': instance.isPosted,
      'totalAmount': instance.totalAmount,
      'createdBy': instance.createdBy,
      'deviceId': instance.deviceId,
      'reversalOfId': instance.reversalOfId,
    };
