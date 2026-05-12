// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) =>
    _JournalEntry(
      entryId: json['entryId'] as String,
      accountRef: json['accountRef'] as String,
      accountCode: json['accountCode'] as String,
      accountName: json['accountName'] as String,
      amount: (json['amount'] as num).toInt(),
      side: $enumDecode(_$EntrySideEnumMap, json['side']),
    );

Map<String, dynamic> _$JournalEntryToJson(_JournalEntry instance) =>
    <String, dynamic>{
      'entryId': instance.entryId,
      'accountRef': instance.accountRef,
      'accountCode': instance.accountCode,
      'accountName': instance.accountName,
      'amount': instance.amount,
      'side': _$EntrySideEnumMap[instance.side]!,
    };

const _$EntrySideEnumMap = {
  EntrySide.debit: 'debit',
  EntrySide.kredit: 'kredit',
};
