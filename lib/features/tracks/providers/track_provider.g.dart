// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trackHash() => r'72ba2f088f5adcb674d531af0a6b07d7ad64bc83';

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

/// See also [track].
@ProviderFor(track)
const trackProvider = TrackFamily();

/// See also [track].
class TrackFamily extends Family<AsyncValue<Track>> {
  /// See also [track].
  const TrackFamily();

  /// See also [track].
  TrackProvider call(
    int id,
  ) {
    return TrackProvider(
      id,
    );
  }

  @override
  TrackProvider getProviderOverride(
    covariant TrackProvider provider,
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
  String? get name => r'trackProvider';
}

/// See also [track].
class TrackProvider extends FutureProvider<Track> {
  /// See also [track].
  TrackProvider(
    int id,
  ) : this._internal(
          (ref) => track(
            ref as TrackRef,
            id,
          ),
          from: trackProvider,
          name: r'trackProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trackHash,
          dependencies: TrackFamily._dependencies,
          allTransitiveDependencies: TrackFamily._allTransitiveDependencies,
          id: id,
        );

  TrackProvider._internal(
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
    FutureOr<Track> Function(TrackRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TrackProvider._internal(
        (ref) => create(ref as TrackRef),
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
  FutureProviderElement<Track> createElement() {
    return _TrackProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TrackRef on FutureProviderRef<Track> {
  /// The parameter `id` of this provider.
  int get id;
}

class _TrackProviderElement extends FutureProviderElement<Track> with TrackRef {
  _TrackProviderElement(super.provider);

  @override
  int get id => (origin as TrackProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
