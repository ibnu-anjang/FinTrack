// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountGroup _$AccountGroupFromJson(Map<String, dynamic> json) =>
    _AccountGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      accountType: $enumDecode(_$AccountCategoryEnumMap, json['accountType']),
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AccountGroupToJson(_AccountGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'accountType': _$AccountCategoryEnumMap[instance.accountType]!,
      'order': instance.order,
    };

const _$AccountCategoryEnumMap = {
  AccountCategory.asset: 'asset',
  AccountCategory.liability: 'liability',
  AccountCategory.equity: 'equity',
  AccountCategory.revenue: 'revenue',
  AccountCategory.expense: 'expense',
};
