// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_group_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accountGroups)
final accountGroupsProvider = AccountGroupsProvider._();

final class AccountGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AccountGroup>>,
          List<AccountGroup>,
          Stream<List<AccountGroup>>
        >
    with
        $FutureModifier<List<AccountGroup>>,
        $StreamProvider<List<AccountGroup>> {
  AccountGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountGroupsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountGroupsHash();

  @$internal
  @override
  $StreamProviderElement<List<AccountGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<AccountGroup>> create(Ref ref) {
    return accountGroups(ref);
  }
}

String _$accountGroupsHash() => r'41068c9bca96b9312504b2c5affd983965452c5b';

@ProviderFor(AccountGroupNotifier)
final accountGroupProvider = AccountGroupNotifierProvider._();

final class AccountGroupNotifierProvider
    extends $NotifierProvider<AccountGroupNotifier, AsyncValue<void>> {
  AccountGroupNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountGroupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountGroupNotifierHash();

  @$internal
  @override
  AccountGroupNotifier create() => AccountGroupNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$accountGroupNotifierHash() =>
    r'9b67e13cb093cf40f2d02cebdd8eb3b5069dc0a1';

abstract class _$AccountGroupNotifier extends $Notifier<AsyncValue<void>> {
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
