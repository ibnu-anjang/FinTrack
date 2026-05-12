// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coa_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(coaList)
final coaListProvider = CoaListProvider._();

final class CoaListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Account>>,
          List<Account>,
          Stream<List<Account>>
        >
    with $FutureModifier<List<Account>>, $StreamProvider<List<Account>> {
  CoaListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coaListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coaListHash();

  @$internal
  @override
  $StreamProviderElement<List<Account>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Account>> create(Ref ref) {
    return coaList(ref);
  }
}

String _$coaListHash() => r'45c91bb03e8311c59ee34c72426c529d198302dd';

@ProviderFor(CoaNotifier)
final coaProvider = CoaNotifierProvider._();

final class CoaNotifierProvider
    extends $NotifierProvider<CoaNotifier, AsyncValue<void>> {
  CoaNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coaNotifierHash();

  @$internal
  @override
  CoaNotifier create() => CoaNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$coaNotifierHash() => r'9c42158287ad39d9775297bd03ee66e64b6e3b0c';

abstract class _$CoaNotifier extends $Notifier<AsyncValue<void>> {
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
