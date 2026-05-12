// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Workspace yang sedang aktif dipakai user

@ProviderFor(ActiveWorkspace)
final activeWorkspaceProvider = ActiveWorkspaceProvider._();

/// Workspace yang sedang aktif dipakai user
final class ActiveWorkspaceProvider
    extends $NotifierProvider<ActiveWorkspace, String?> {
  /// Workspace yang sedang aktif dipakai user
  ActiveWorkspaceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeWorkspaceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeWorkspaceHash();

  @$internal
  @override
  ActiveWorkspace create() => ActiveWorkspace();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$activeWorkspaceHash() => r'1bc90466182435d00626e765c6d05845b0741c73';

/// Workspace yang sedang aktif dipakai user

abstract class _$ActiveWorkspace extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Semua workspace milik/diikuti user yang sedang login

@ProviderFor(userWorkspaces)
final userWorkspacesProvider = UserWorkspacesProvider._();

/// Semua workspace milik/diikuti user yang sedang login

final class UserWorkspacesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Workspace>>,
          List<Workspace>,
          Stream<List<Workspace>>
        >
    with $FutureModifier<List<Workspace>>, $StreamProvider<List<Workspace>> {
  /// Semua workspace milik/diikuti user yang sedang login
  UserWorkspacesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userWorkspacesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userWorkspacesHash();

  @$internal
  @override
  $StreamProviderElement<List<Workspace>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Workspace>> create(Ref ref) {
    return userWorkspaces(ref);
  }
}

String _$userWorkspacesHash() => r'3df1abc40147f80c72f529916a7aed369334971f';

@ProviderFor(WorkspaceNotifier)
final workspaceProvider = WorkspaceNotifierProvider._();

final class WorkspaceNotifierProvider
    extends $NotifierProvider<WorkspaceNotifier, AsyncValue<void>> {
  WorkspaceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workspaceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workspaceNotifierHash();

  @$internal
  @override
  WorkspaceNotifier create() => WorkspaceNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$workspaceNotifierHash() => r'a0cee89c6b347be23e96fd8ec7e9f00d493eb35d';

abstract class _$WorkspaceNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
