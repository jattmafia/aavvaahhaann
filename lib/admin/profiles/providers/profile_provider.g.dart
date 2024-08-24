// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminProfileHash() => r'2f41d28f76c4ab4d6e5e438219430df6af8da063';

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

/// See also [adminProfile].
@ProviderFor(adminProfile)
const adminProfileProvider = AdminProfileFamily();

/// See also [adminProfile].
class AdminProfileFamily extends Family<AsyncValue<Profile>> {
  /// See also [adminProfile].
  const AdminProfileFamily();

  /// See also [adminProfile].
  AdminProfileProvider call(
    int id,
  ) {
    return AdminProfileProvider(
      id,
    );
  }

  @override
  AdminProfileProvider getProviderOverride(
    covariant AdminProfileProvider provider,
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
  String? get name => r'adminProfileProvider';
}

/// See also [adminProfile].
class AdminProfileProvider extends FutureProvider<Profile> {
  /// See also [adminProfile].
  AdminProfileProvider(
    int id,
  ) : this._internal(
          (ref) => adminProfile(
            ref as AdminProfileRef,
            id,
          ),
          from: adminProfileProvider,
          name: r'adminProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adminProfileHash,
          dependencies: AdminProfileFamily._dependencies,
          allTransitiveDependencies:
              AdminProfileFamily._allTransitiveDependencies,
          id: id,
        );

  AdminProfileProvider._internal(
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
    FutureOr<Profile> Function(AdminProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminProfileProvider._internal(
        (ref) => create(ref as AdminProfileRef),
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
  FutureProviderElement<Profile> createElement() {
    return _AdminProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminProfileProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AdminProfileRef on FutureProviderRef<Profile> {
  /// The parameter `id` of this provider.
  int get id;
}

class _AdminProfileProviderElement extends FutureProviderElement<Profile>
    with AdminProfileRef {
  _AdminProfileProviderElement(super.provider);

  @override
  int get id => (origin as AdminProfileProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
