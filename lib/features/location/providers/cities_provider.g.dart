// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cities_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$citiesHash() => r'a10c87e6982ec4533e5ab3bb91da3237c69b7e9c';

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

/// See also [cities].
@ProviderFor(cities)
const citiesProvider = CitiesFamily();

/// See also [cities].
class CitiesFamily extends Family<AsyncValue<List<String>>> {
  /// See also [cities].
  const CitiesFamily();

  /// See also [cities].
  CitiesProvider call(
    String ciso,
    String siso,
  ) {
    return CitiesProvider(
      ciso,
      siso,
    );
  }

  @override
  CitiesProvider getProviderOverride(
    covariant CitiesProvider provider,
  ) {
    return call(
      provider.ciso,
      provider.siso,
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
  String? get name => r'citiesProvider';
}

/// See also [cities].
class CitiesProvider extends AutoDisposeFutureProvider<List<String>> {
  /// See also [cities].
  CitiesProvider(
    String ciso,
    String siso,
  ) : this._internal(
          (ref) => cities(
            ref as CitiesRef,
            ciso,
            siso,
          ),
          from: citiesProvider,
          name: r'citiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$citiesHash,
          dependencies: CitiesFamily._dependencies,
          allTransitiveDependencies: CitiesFamily._allTransitiveDependencies,
          ciso: ciso,
          siso: siso,
        );

  CitiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ciso,
    required this.siso,
  }) : super.internal();

  final String ciso;
  final String siso;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(CitiesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CitiesProvider._internal(
        (ref) => create(ref as CitiesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ciso: ciso,
        siso: siso,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _CitiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CitiesProvider && other.ciso == ciso && other.siso == siso;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ciso.hashCode);
    hash = _SystemHash.combine(hash, siso.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CitiesRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `ciso` of this provider.
  String get ciso;

  /// The parameter `siso` of this provider.
  String get siso;
}

class _CitiesProviderElement
    extends AutoDisposeFutureProviderElement<List<String>> with CitiesRef {
  _CitiesProviderElement(super.provider);

  @override
  String get ciso => (origin as CitiesProvider).ciso;
  @override
  String get siso => (origin as CitiesProvider).siso;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
