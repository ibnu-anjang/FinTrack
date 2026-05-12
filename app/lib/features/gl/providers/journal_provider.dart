import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../models/journal_entry.dart';
import '../../../models/transaction.dart';
import '../../workspace/providers/workspace_provider.dart';

part 'journal_provider.g.dart';

final _db = FirebaseFirestore.instance;
const _uuid = Uuid();

@Riverpod(keepAlive: true)
Stream<List<Transaction>> journalList(Ref ref) {
  final workspaceId = ref.watch(activeWorkspaceProvider);
  if (workspaceId == null) return const Stream.empty();
  return Stream.fromFuture(Future.value(workspaceId)).asyncExpand((id) =>
      _db
          .collection('workspaces')
          .doc(id)
          .collection('transactions')
          .orderBy('date', descending: true)
          .limit(100)
          .snapshots()
          .map((snap) => snap.docs
              .map((d) => Transaction.fromJson({...d.data(), 'transactionId': d.id}))
              .toList()));
}

@riverpod
Stream<List<JournalEntry>> journalEntries(Ref ref, String workspaceId, String transactionId) {
  return Stream.fromFuture(Future.value(null)).asyncExpand((_) =>
      _db
          .collection('workspaces')
          .doc(workspaceId)
          .collection('transactions')
          .doc(transactionId)
          .collection('journal_entries')
          .snapshots()
          .map((snap) => snap.docs
              .map((d) => JournalEntry.fromJson({...d.data(), 'entryId': d.id}))
              .toList()));
}

@riverpod
class JournalNotifier extends _$JournalNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> saveJournal({
    required String workspaceId,
    required DateTime date,
    required String description,
    required List<JournalEntry> entries,
    String sourceModule = 'GL',
    String? reversalOfId,
  }) async {
    final totalDebit = entries.where((e) => e.side == EntrySide.debit).fold(0, (s, e) => s + e.amount);
    final totalKredit = entries.where((e) => e.side == EntrySide.kredit).fold(0, (s, e) => s + e.amount);

    if (entries.length < 2) {
      state = AsyncError('Jurnal minimal 2 baris entry', StackTrace.current);
      return false;
    }
    if (totalDebit != totalKredit) {
      state = AsyncError(
        'Tidak balance: Debit $totalDebit Sen ≠ Kredit $totalKredit Sen',
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('Sesi berakhir, silakan login ulang');

      final txId = _uuid.v4();
      final txRef = _db
          .collection('workspaces')
          .doc(workspaceId)
          .collection('transactions')
          .doc(txId);

      final tx = Transaction(
        transactionId: txId,
        date: date,
        description: description,
        sourceModule: sourceModule,
        isPosted: false,
        totalAmount: totalDebit,
        createdBy: uid,
        reversalOfId: reversalOfId,
      );

      final batch = _db.batch();
      batch.set(txRef, tx.toJson());
      for (final entry in entries) {
        batch.set(txRef.collection('journal_entries').doc(entry.entryId), entry.toJson());
      }
      await batch.commit();
    });

    return !state.hasError;
  }

  Future<void> postJournal(String workspaceId, String transactionId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _db.runTransaction((tx) async {
        final ref = _db
            .collection('workspaces')
            .doc(workspaceId)
            .collection('transactions')
            .doc(transactionId);
        final snap = await tx.get(ref);
        if (!snap.exists) throw Exception('Transaksi tidak ditemukan');
        if (snap.data()!['isPosted'] == true) throw Exception('Sudah diposting');
        tx.update(ref, {'isPosted': true});
      });
    });
  }

  Future<bool> reverseJournal(
      String workspaceId, Transaction original, List<JournalEntry> originalEntries) async {
    if (!original.isPosted) {
      state = AsyncError('Hanya jurnal posted yang bisa dibalik', StackTrace.current);
      return false;
    }

    final reversedEntries = originalEntries
        .map((e) => e.copyWith(
              entryId: _uuid.v4(),
              side: e.side == EntrySide.debit ? EntrySide.kredit : EntrySide.debit,
            ))
        .toList();

    return saveJournal(
      workspaceId: workspaceId,
      date: DateTime.now(),
      description: 'PEMBALIKAN: ${original.description}',
      entries: reversedEntries,
      sourceModule: 'GL',
      reversalOfId: original.transactionId,
    );
  }
}
