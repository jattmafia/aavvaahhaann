// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_sessions_analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playSessionAnalyticsHash() =>
    r'b9482f4c42f1b06b310ddf96c19176ec8ceee308';

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

/// See also [playSessionAnalytics].
@ProviderFor(playSessionAnalytics)
const playSessionAnalyticsProvider = PlaySessionAnalyticsFamily();

/// See also [playSessionAnalytics].
class PlaySessionAnalyticsFamily
    extends Family<AsyncValue<PlaySessionAnalytics>> {
  /// See also [playSessionAnalytics].
  const PlaySessionAnalyticsFamily();

  /// See also [playSessionAnalytics].
  PlaySessionAnalyticsProvider call(
    DateTime startDate,
    DateTime endDate,
  ) {
    return PlaySessionAnalyticsProvider(
      startDate,
      endDate,
    );
  }

  @override
  PlaySessionAnalyticsProvider getProviderOverride(
    covariant PlaySessionAnalyticsProvider provider,
  ) {
    return call(
      provider.startDate,
      provider.endDate,
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
  String? get name => r'playSessionAnalyticsProvider';
}

/// See also [playSessionAnalytics].
class PlaySessionAnalyticsProvider
    extends FutureProvider<PlaySessionAnalytics> {
  /// See also [playSessionAnalytics].
  PlaySessionAnalyticsProvider(
    DateTime startDate,
    DateTime endDate,
  ) : this._internal(
          (ref) => playSessionAnalytics(
            ref as PlaySessionAnalyticsRef,
            startDate,
            endDate,
          ),
          from: playSessionAnalyticsProvider,
          name: r'playSessionAnalyticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$playSessionAnalyticsHash,
          dependencies: PlaySessionAnalyticsFamily._dependencies,
          allTransitiveDependencies:
              PlaySessionAnalyticsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  PlaySessionAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;

  @override
  Override overrideWith(
    FutureOr<PlaySessionAnalytics> Function(PlaySessionAnalyticsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlaySessionAnalyticsProvider._internal(
        (ref) => create(ref as PlaySessionAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  FutureProviderElement<PlaySessionAnalytics> createElement() {
    return _PlaySessionAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaySessionAnalyticsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PlaySessionAnalyticsRef on FutureProviderRef<PlaySessionAnalytics> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _PlaySessionAnalyticsProviderElement
    extends FutureProviderElement<PlaySessionAnalytics>
    with PlaySessionAnalyticsRef {
  _PlaySessionAnalyticsProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as PlaySessionAnalyticsProvider).startDate;
  @override
  DateTime get endDate => (origin as PlaySessionAnalyticsProvider).endDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
