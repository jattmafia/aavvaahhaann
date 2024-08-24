// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_sessions_analytics_of_user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playSessionAnalyticsOfUserHash() =>
    r'54e35fb4f9b425f7e6ad615c18cb8ad00960ee77';

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

/// See also [playSessionAnalyticsOfUser].
@ProviderFor(playSessionAnalyticsOfUser)
const playSessionAnalyticsOfUserProvider = PlaySessionAnalyticsOfUserFamily();

/// See also [playSessionAnalyticsOfUser].
class PlaySessionAnalyticsOfUserFamily
    extends Family<AsyncValue<PlaySessionAnalytics>> {
  /// See also [playSessionAnalyticsOfUser].
  const PlaySessionAnalyticsOfUserFamily();

  /// See also [playSessionAnalyticsOfUser].
  PlaySessionAnalyticsOfUserProvider call(
    int userId,
  ) {
    return PlaySessionAnalyticsOfUserProvider(
      userId,
    );
  }

  @override
  PlaySessionAnalyticsOfUserProvider getProviderOverride(
    covariant PlaySessionAnalyticsOfUserProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'playSessionAnalyticsOfUserProvider';
}

/// See also [playSessionAnalyticsOfUser].
class PlaySessionAnalyticsOfUserProvider
    extends FutureProvider<PlaySessionAnalytics> {
  /// See also [playSessionAnalyticsOfUser].
  PlaySessionAnalyticsOfUserProvider(
    int userId,
  ) : this._internal(
          (ref) => playSessionAnalyticsOfUser(
            ref as PlaySessionAnalyticsOfUserRef,
            userId,
          ),
          from: playSessionAnalyticsOfUserProvider,
          name: r'playSessionAnalyticsOfUserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$playSessionAnalyticsOfUserHash,
          dependencies: PlaySessionAnalyticsOfUserFamily._dependencies,
          allTransitiveDependencies:
              PlaySessionAnalyticsOfUserFamily._allTransitiveDependencies,
          userId: userId,
        );

  PlaySessionAnalyticsOfUserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  Override overrideWith(
    FutureOr<PlaySessionAnalytics> Function(
            PlaySessionAnalyticsOfUserRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlaySessionAnalyticsOfUserProvider._internal(
        (ref) => create(ref as PlaySessionAnalyticsOfUserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  FutureProviderElement<PlaySessionAnalytics> createElement() {
    return _PlaySessionAnalyticsOfUserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaySessionAnalyticsOfUserProvider &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PlaySessionAnalyticsOfUserRef on FutureProviderRef<PlaySessionAnalytics> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _PlaySessionAnalyticsOfUserProviderElement
    extends FutureProviderElement<PlaySessionAnalytics>
    with PlaySessionAnalyticsOfUserRef {
  _PlaySessionAnalyticsOfUserProviderElement(super.provider);

  @override
  int get userId => (origin as PlaySessionAnalyticsOfUserProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
