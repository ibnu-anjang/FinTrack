import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/account.dart';
import '../../../models/account_group.dart';
import '../../workspace/providers/workspace_provider.dart';

part 'account_group_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<AccountGroup>> accountGroups(Ref ref) {
  final workspaceId = ref.watch(activeWorkspaceProvider);
  if (workspaceId == null) return const Stream.empty();
  return Stream.fromFuture(Future.value(workspaceId)).asyncExpand((id) =>
      FirebaseFirestore.instance
          .collection('workspaces')
          .doc(id)
          .collection('groups')
          .orderBy('order')
          .snapshots()
          .map((snap) => snap.docs
              .map((d) => AccountGroup.fromJson({...d.data(), 'id': d.id}))
              .toList()));
}

@riverpod
class AccountGroupNotifier extends _$AccountGroupNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  CollectionReference<Map<String, dynamic>> _col(String workspaceId) =>
      FirebaseFirestore.instance
          .collection('workspaces')
          .doc(workspaceId)
          .collection('groups');

  Future<void> seedDefaultGroups(String workspaceId) async {
    final col = _col(workspaceId);
    for (final g in kDefaultGroups()) {
      await col.doc(g.id).set(g.toJson()..remove('id'));
    }
  }

  Future<void> addGroup(String workspaceId, AccountGroup group) async {
    final data = group.toJson()..remove('id');
    await _col(workspaceId).doc(group.id).set(data);
  }

  Future<void> updateGroup(String workspaceId, AccountGroup group) async {
    final data = group.toJson()..remove('id');
    await _col(workspaceId).doc(group.id).update(data);
  }

  Future<void> deleteGroup(String workspaceId, String id) async {
    await _col(workspaceId).doc(id).delete();
  }
}

/// Helper: kembalikan grup default berdasarkan AccountCategory
AccountGroup defaultGroupFor(AccountCategory cat) =>
    kDefaultGroups().firstWhere((g) => g.accountType == cat);
