import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/account.dart';
import '../../workspace/providers/workspace_provider.dart';

part 'coa_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<Account>> coaList(Ref ref) {
  final workspaceId = ref.watch(activeWorkspaceProvider);
  if (workspaceId == null) return const Stream.empty();
  // Defer startListen ke microtask berikutnya agar tidak crash
  // saat Riverpod membangun provider di dalam Flutter build phase (web)
  return Stream.fromFuture(Future.value(workspaceId)).asyncExpand((id) =>
      FirebaseFirestore.instance
          .collection('workspaces')
          .doc(id)
          .collection('accounts')
          .orderBy('accountCode')
          .snapshots()
          .map((snap) => snap.docs
              .map((d) => Account.fromJson({...d.data(), 'id': d.id}))
              .toList()));
}

@riverpod
class CoaNotifier extends _$CoaNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  CollectionReference<Map<String, dynamic>> _col(String workspaceId) =>
      FirebaseFirestore.instance
          .collection('workspaces')
          .doc(workspaceId)
          .collection('accounts');

  Future<void> seedDefaultCoa(String workspaceId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final col = _col(workspaceId);
      final batch = FirebaseFirestore.instance.batch();
      for (final data in kDefaultCoa) {
        batch.set(col.doc(data['id'] as String), {...data, 'isActive': true});
      }
      await batch.commit();
    });
  }

  Future<void> addAccount(String workspaceId, Account account) async {
    final data = account.toJson()..remove('id');
    await _col(workspaceId).doc(account.id).set(data);
  }

  Future<void> updateAccount(String workspaceId, Account account) async {
    final data = account.toJson()..remove('id');
    await _col(workspaceId).doc(account.id).update(data);
  }

  Future<void> toggleActive(
      String workspaceId, String id, bool isActive) async {
    await _col(workspaceId).doc(id).update({'isActive': isActive});
  }

  Future<void> deleteAccount(String workspaceId, String id) async {
    await _col(workspaceId).doc(id).delete();
  }
}
