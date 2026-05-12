import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../features/auth/auth_provider.dart';
import '../../../models/workspace.dart';

part 'workspace_provider.g.dart';

const _uuid = Uuid();
final _db = FirebaseFirestore.instance;

/// Workspace yang sedang aktif dipakai user
@Riverpod(keepAlive: true)
class ActiveWorkspace extends _$ActiveWorkspace {
  @override
  String? build() => null;

  void select(String workspaceId) => state = workspaceId;
  void clear() => state = null;
}

/// Semua workspace milik/diikuti user yang sedang login
@Riverpod(keepAlive: true)
Stream<List<Workspace>> userWorkspaces(Ref ref) {
  // Watch authState agar provider rebuild otomatis saat ganti user
  final authAsync = ref.watch(authStateProvider);
  final uid = authAsync.asData?.value?.uid;
  if (uid == null) return const Stream.empty();
  return _db
      .collection('workspaces')
      .where('memberIds', arrayContains: uid)
      .snapshots()
      .map((snap) => snap.docs
          .map((d) => Workspace.fromJson({...d.data(), 'id': d.id}))
          .toList());
}

@riverpod
class WorkspaceNotifier extends _$WorkspaceNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<String?> createWorkspace({
    required String name,
    String? description,
  }) async {
    state = const AsyncLoading();
    String? newId;
    state = await AsyncValue.guard(() async {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('Sesi berakhir, silakan login ulang');
      newId = _uuid.v4();
      final workspace = Workspace(
        id: newId!,
        name: name.trim(),
        ownerId: uid,
        memberIds: [uid],
        description: description?.trim(),
      );
      await _db
          .collection('workspaces')
          .doc(newId)
          .set(workspace.toJson());
    });
    return state.hasError ? null : newId;
  }
}
