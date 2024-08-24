// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'states_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$statesHash() => r'4eddc86f9aa5ef52e9454e374ccb7fc6d59a6a43';

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

/// See also [states].
@ProviderFor(states)
const statesProvider = StatesFamily();

/// See also [states].
class StatesFamily extends Family<AsyncValue<List<LocObj>>> {
  /// See also [states].
  const StatesFamily();

  /// See also [states].
  StatesProvider call(
    String ciso,
  ) {
    return StatesProvider(
      ciso,
    );
  }

  @override
  StatesProvider getProviderOverride(
    covariant StatesProvider provider,
  ) {
    return call(
      provider.ciso,
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
  String? get name => r'statesProvider';
}

/// See also [states].
class StatesProvider extends AutoDisposeFutureProvider<List<LocObj>> {
  /// See also [states].
  StatesProvider(
    String ciso,
  ) : this._internal(
          (ref) => states(
            ref as StatesRef,
            ciso,
          ),
          from: statesProvider,
          name: r'statesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$statesHash,
          dependencies: StatesFamily._dependencies,
          allTransitiveDependencies: StatesFamily._allTransitiveDependencies,
          ciso: ciso,
        );

  StatesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ciso,
  }) : super.internal();

  final String ciso;

  @override
  Override overrideWith(
    FutureOr<List<LocObj>> Function(StatesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StatesProvider._internal(
        (ref) => create(ref as StatesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ciso: ciso,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<LocObj>> createElement() {
    return _StatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StatesProvider && other.ciso == ciso;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ciso.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StatesRef on AutoDisposeFutureProviderRef<List<LocObj>> {
  /// The parameter `ciso` of this provider.
  String get ciso;
}

class _StatesProviderElement
    extends AutoDisposeFutureProviderElement<List<LocObj>> with StatesRef {
  _StatesProviderElement(super.provider);

  @override
  String get ciso => (origin as StatesProvider).ciso;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
