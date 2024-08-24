// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bannerStatsHash() => r'6c2c86b14c33d4ffe9c346720fc4bea336bce2a8';

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

/// See also [bannerStats].
@ProviderFor(bannerStats)
const bannerStatsProvider = BannerStatsFamily();

/// See also [bannerStats].
class BannerStatsFamily extends Family<AsyncValue<Map<String, BannerStats>>> {
  /// See also [bannerStats].
  const BannerStatsFamily();

  /// See also [bannerStats].
  BannerStatsProvider call(
    List<String> bannerIds,
  ) {
    return BannerStatsProvider(
      bannerIds,
    );
  }

  @override
  BannerStatsProvider getProviderOverride(
    covariant BannerStatsProvider provider,
  ) {
    return call(
      provider.bannerIds,
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
  String? get name => r'bannerStatsProvider';
}

/// See also [bannerStats].
class BannerStatsProvider
    extends AutoDisposeFutureProvider<Map<String, BannerStats>> {
  /// See also [bannerStats].
  BannerStatsProvider(
    List<String> bannerIds,
  ) : this._internal(
          (ref) => bannerStats(
            ref as BannerStatsRef,
            bannerIds,
          ),
          from: bannerStatsProvider,
          name: r'bannerStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bannerStatsHash,
          dependencies: BannerStatsFamily._dependencies,
          allTransitiveDependencies:
              BannerStatsFamily._allTransitiveDependencies,
          bannerIds: bannerIds,
        );

  BannerStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bannerIds,
  }) : super.internal();

  final List<String> bannerIds;

  @override
  Override overrideWith(
    FutureOr<Map<String, BannerStats>> Function(BannerStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BannerStatsProvider._internal(
        (ref) => create(ref as BannerStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bannerIds: bannerIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, BannerStats>> createElement() {
    return _BannerStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BannerStatsProvider && other.bannerIds == bannerIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bannerIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BannerStatsRef on AutoDisposeFutureProviderRef<Map<String, BannerStats>> {
  /// The parameter `bannerIds` of this provider.
  List<String> get bannerIds;
}

class _BannerStatsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, BannerStats>>
    with BannerStatsRef {
  _BannerStatsProviderElement(super.provider);

  @override
  List<String> get bannerIds => (origin as BannerStatsProvider).bannerIds;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
