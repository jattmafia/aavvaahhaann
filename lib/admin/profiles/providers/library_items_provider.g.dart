// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_items_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminLibraryItemsHash() => r'5d20e22e4ae74f41dae208de277a854e737a766a';

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

/// See also [adminLibraryItems].
@ProviderFor(adminLibraryItems)
const adminLibraryItemsProvider = AdminLibraryItemsFamily();

/// See also [adminLibraryItems].
class AdminLibraryItemsFamily extends Family<AsyncValue<List<LibraryItem>>> {
  /// See also [adminLibraryItems].
  const AdminLibraryItemsFamily();

  /// See also [adminLibraryItems].
  AdminLibraryItemsProvider call(
    int id,
  ) {
    return AdminLibraryItemsProvider(
      id,
    );
  }

  @override
  AdminLibraryItemsProvider getProviderOverride(
    covariant AdminLibraryItemsProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'adminLibraryItemsProvider';
}

/// See also [adminLibraryItems].
class AdminLibraryItemsProvider
    extends AutoDisposeFutureProvider<List<LibraryItem>> {
  /// See also [adminLibraryItems].
  AdminLibraryItemsProvider(
    int id,
  ) : this._internal(
          (ref) => adminLibraryItems(
            ref as AdminLibraryItemsRef,
            id,
          ),
          from: adminLibraryItemsProvider,
          name: r'adminLibraryItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adminLibraryItemsHash,
          dependencies: AdminLibraryItemsFamily._dependencies,
          allTransitiveDependencies:
              AdminLibraryItemsFamily._allTransitiveDependencies,
          id: id,
        );

  AdminLibraryItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<List<LibraryItem>> Function(AdminLibraryItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminLibraryItemsProvider._internal(
        (ref) => create(ref as AdminLibraryItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<LibraryItem>> createElement() {
    return _AdminLibraryItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminLibraryItemsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AdminLibraryItemsRef on AutoDisposeFutureProviderRef<List<LibraryItem>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _AdminLibraryItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<LibraryItem>>
    with AdminLibraryItemsRef {
  _AdminLibraryItemsProviderElement(super.provider);

  @override
  int get id => (origin as AdminLibraryItemsProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
