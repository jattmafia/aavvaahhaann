// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pages_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pagesNotifierHash() => r'6a0964f0e65b3e6f3e5fbbeea3888fda8649c439';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PagesNotifier
    extends BuildlessAutoDisposeNotifier<AdminPagesState> {
  late final PagesData pagesData;

  AdminPagesState build(
    PagesData pagesData,
  );
}

/// See also [PagesNotifier].
@ProviderFor(PagesNotifier)
const pagesNotifierProvider = PagesNotifierFamily();

/// See also [PagesNotifier].
class PagesNotifierFamily extends Family<AdminPagesState> {
  /// See also [PagesNotifier].
  const PagesNotifierFamily();

  /// See also [PagesNotifier].
  PagesNotifierProvider call(
    PagesData pagesData,
  ) {
    return PagesNotifierProvider(
      pagesData,
    );
  }

  @override
  PagesNotifierProvider getProviderOverride(
    covariant PagesNotifierProvider provider,
  ) {
    return call(
      provider.pagesData,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pagesNotifierProvider';
}

/// See also [PagesNotifier].
class PagesNotifierProvider
    extends AutoDisposeNotifierProviderImpl<PagesNotifier, AdminPagesState> {
  /// See also [PagesNotifier].
  PagesNotifierProvider(
    PagesData pagesData,
  ) : this._internal(
          () => PagesNotifier()..pagesData = pagesData,
          from: pagesNotifierProvider,
          name: r'pagesNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pagesNotifierHash,
          dependencies: PagesNotifierFamily._dependencies,
          allTransitiveDependencies:
              PagesNotifierFamily._allTransitiveDependencies,
          pagesData: pagesData,
        );

  PagesNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pagesData,
  }) : super.internal();

  final PagesData pagesData;

  @override
  AdminPagesState runNotifierBuild(
    covariant PagesNotifier notifier,
  ) {
    return notifier.build(
      pagesData,
    );
  }

  @override
  Override overrideWith(PagesNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PagesNotifierProvider._internal(
        () => create()..pagesData = pagesData,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pagesData: pagesData,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PagesNotifier, AdminPagesState>
      createElement() {
    return _PagesNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PagesNotifierProvider && other.pagesData == pagesData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pagesData.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PagesNotifierRef on AutoDisposeNotifierProviderRef<AdminPagesState> {
  /// The parameter `pagesData` of this provider.
  PagesData get pagesData;
}

class _PagesNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<PagesNotifier, AdminPagesState>
    with PagesNotifierRef {
  _PagesNotifierProviderElement(super.provider);

  @override
  PagesData get pagesData => (origin as PagesNotifierProvider).pagesData;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
