import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

enum EntrySide { debit, kredit }

@freezed
abstract class JournalEntry with _$JournalEntry {
  const factory JournalEntry({
    required String entryId,
    required String accountRef,   // path Firestore: "accounts/{accountCode}"
    required String accountCode,  // denormalized untuk display
    required String accountName,  // denormalized untuk display
    required int amount,          // dalam Sen (satuan terkecil)
    required EntrySide side,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);
}
