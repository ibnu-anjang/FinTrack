import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

// Tidak ada List<JournalEntry> di sini — entries disimpan sebagai sub-collection
// Firestore: transactions/{transactionId}/journal_entries/{entryId}

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String transactionId,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime date,
    required String description,
    required String sourceModule,   // GL, AR, AP, INV, FA
    @Default(false) bool isPosted,
    @Default(0) int totalAmount,    // total debit dalam sen (denormalisasi untuk performa list)
    required String createdBy,      // userId — audit trail
    String? deviceId,               // audit trail
    String? reversalOfId,           // jika ini jurnal pembalikan
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

DateTime _timestampFromJson(dynamic v) {
  if (v is Timestamp) return v.toDate();
  if (v is String) return DateTime.parse(v);
  return DateTime.now();
}

dynamic _timestampToJson(DateTime d) => Timestamp.fromDate(d);
