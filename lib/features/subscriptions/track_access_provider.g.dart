// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_access_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trackAccessHash() => r'7270b6a79c55da40945d4dcfd53eb5833a36739c';

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

/// See also [trackAccess].
@ProviderFor(trackAccess)
const trackAccessProvider = TrackAccessFamily();

/// See also [trackAccess].
class TrackAccessFamily extends Family<bool> {
  /// See also [trackAccess].
  const TrackAccessFamily();

  /// See also [trackAccess].
  TrackAccessProvider call(
    int trackId,
  ) {
    return TrackAccessProvider(
      trackId,
    );
  }

  @override
  TrackAccessProvider getProviderOverride(
    covariant TrackAccessProvider provider,
  ) {
    return call(
      provider.trackId,
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
  String? get name => r'trackAccessProvider';
}

/// See also [trackAccess].
class TrackAccessProvider extends AutoDisposeProvider<bool> {
  /// See also [trackAccess].
  TrackAccessProvider(
    int trackId,
  ) : this._internal(
          (ref) => trackAccess(
            ref as TrackAccessRef,
            trackId,
          ),
          from: trackAccessProvider,
          name: r'trackAccessProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trackAccessHash,
          dependencies: TrackAccessFamily._dependencies,
          allTransitiveDependencies:
              TrackAccessFamily._allTransitiveDependencies,
          trackId: trackId,
        );

  TrackAccessProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.trackId,
  }) : super.internal();

  final int trackId;

  @override
  Override overrideWith(
    bool Function(TrackAccessRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TrackAccessProvider._internal(
        (ref) => create(ref as TrackAccessRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        trackId: trackId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _TrackAccessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackAccessProvider && other.trackId == trackId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, trackId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TrackAccessRef on AutoDisposeProviderRef<bool> {
  /// The parameter `trackId` of this provider.
  int get trackId;
}

class _TrackAccessProviderElement extends AutoDisposeProviderElement<bool>
    with TrackAccessRef {
  _TrackAccessProviderElement(super.provider);

  @override
  int get trackId => (origin as TrackAccessProvider).trackId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
