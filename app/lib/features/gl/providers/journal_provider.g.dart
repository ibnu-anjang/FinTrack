// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(journalList)
final journalListProvider = JournalListProvider._();

final class JournalListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Transaction>>,
          List<Transaction>,
          Stream<List<Transaction>>
        >
    with
        $FutureModifier<List<Transaction>>,
        $StreamProvider<List<Transaction>> {
  JournalListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journalListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journalListHash();

  @$internal
  @override
  $StreamProviderElement<List<Transaction>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Transaction>> create(Ref ref) {
    return journalList(ref);
  }
}

String _$journalListHash() => r'b3801e75b52524bb6f04afaddb4a712636ced88f';

@ProviderFor(journalEntries)
final journalEntriesProvider = JournalEntriesFamily._();

final class JournalEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<JournalEntry>>,
          List<JournalEntry>,
          Stream<List<JournalEntry>>
        >
    with
        $FutureModifier<List<JournalEntry>>,
        $StreamProvider<List<JournalEntry>> {
  JournalEntriesProvider._({
    required JournalEntriesFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'journalEntriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$journalEntriesHash();

  @override
  String toString() {
    return r'journalEntriesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<JournalEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<JournalEntry>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return journalEntries(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is JournalEntriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$journalEntriesHash() => r'17af22157b6d8426f7249911da5748c0664808c2';

final class JournalEntriesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<JournalEntry>>,
          (String, String)
        > {
  JournalEntriesFamily._()
    : super(
        retry: null,
        name: r'journalEntriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  JournalEntriesProvider call(String workspaceId, String transactionId) =>
      JournalEntriesProvider._(
        argument: (workspaceId, transactionId),
        from: this,
      );

  @override
  String toString() => r'journalEntriesProvider';
}

@ProviderFor(JournalNotifier)
final journalProvider = JournalNotifierProvider._();

final class JournalNotifierProvider
    extends $NotifierProvider<JournalNotifier, AsyncValue<void>> {
  JournalNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journalNotifierHash();

  @$internal
  @override
  JournalNotifier create() => JournalNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$journalNotifierHash() => r'61fc992d4dd4f5fa812748c45b72e7dbf2fe5a09';

abstract class _$JournalNotifier extends $Notifier<AsyncValue<void>> {
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
