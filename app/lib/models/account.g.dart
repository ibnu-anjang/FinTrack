// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
  id: json['id'] as String,
  accountCode: json['accountCode'] as String,
  name: json['name'] as String,
  category: $enumDecode(_$AccountCategoryEnumMap, json['category']),
  normalBalance: $enumDecode(_$NormalBalanceEnumMap, json['normalBalance']),
  isActive: json['isActive'] as bool? ?? true,
  parentCode: json['parentCode'] as String?,
  group: json['group'] as String?,
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'id': instance.id,
  'accountCode': instance.accountCode,
  'name': instance.name,
  'category': _$AccountCategoryEnumMap[instance.category]!,
  'normalBalance': _$NormalBalanceEnumMap[instance.normalBalance]!,
  'isActive': instance.isActive,
  'parentCode': instance.parentCode,
  'group': instance.group,
};

const _$AccountCategoryEnumMap = {
  AccountCategory.asset: 'asset',
  AccountCategory.liability: 'liability',
  AccountCategory.equity: 'equity',
  AccountCategory.revenue: 'revenue',
  AccountCategory.expense: 'expense',
};

const _$NormalBalanceEnumMap = {
  NormalBalance.debit: 'debit',
  NormalBalance.kredit: 'kredit',
};
