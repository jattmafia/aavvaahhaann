// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_metrics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trackMetricsHash() => r'0fc38ca7881b48727d81023e3ba4c93fc5a272cb';

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

/// See also [trackMetrics].
@ProviderFor(trackMetrics)
const trackMetricsProvider = TrackMetricsFamily();

/// See also [trackMetrics].
class TrackMetricsFamily extends Family<AsyncValue<TrackMetrics>> {
  /// See also [trackMetrics].
  const TrackMetricsFamily();

  /// See also [trackMetrics].
  TrackMetricsProvider call(
    int id,
    DateTime start,
    DateTime end,
  ) {
    return TrackMetricsProvider(
      id,
      start,
      end,
    );
  }

  @override
  TrackMetricsProvider getProviderOverride(
    covariant TrackMetricsProvider provider,
  ) {
    return call(
      provider.id,
      provider.start,
      provider.end,
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
  String? get name => r'trackMetricsProvider';
}

/// See also [trackMetrics].
class TrackMetricsProvider extends AutoDisposeFutureProvider<TrackMetrics> {
  /// See also [trackMetrics].
  TrackMetricsProvider(
    int id,
    DateTime start,
    DateTime end,
  ) : this._internal(
          (ref) => trackMetrics(
            ref as TrackMetricsRef,
            id,
            start,
            end,
          ),
          from: trackMetricsProvider,
          name: r'trackMetricsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trackMetricsHash,
          dependencies: TrackMetricsFamily._dependencies,
          allTransitiveDependencies:
              TrackMetricsFamily._allTransitiveDependencies,
          id: id,
          start: start,
          end: end,
        );

  TrackMetricsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.start,
    required this.end,
  }) : super.internal();

  final int id;
  final DateTime start;
  final DateTime end;

  @override
  Override overrideWith(
    FutureOr<TrackMetrics> Function(TrackMetricsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TrackMetricsProvider._internal(
        (ref) => create(ref as TrackMetricsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        start: start,
        end: end,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TrackMetrics> createElement() {
    return _TrackMetricsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackMetricsProvider &&
        other.id == id &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, start.hashCode);
    hash = _SystemHash.combine(hash, end.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TrackMetricsRef on AutoDisposeFutureProviderRef<TrackMetrics> {
  /// The parameter `id` of this provider.
  int get id;

  /// The parameter `start` of this provider.
  DateTime get start;

  /// The parameter `end` of this provider.
  DateTime get end;
}

class _TrackMetricsProviderElement
    extends AutoDisposeFutureProviderElement<TrackMetrics>
    with TrackMetricsRef {
  _TrackMetricsProviderElement(super.provider);

  @override
  int get id => (origin as TrackMetricsProvider).id;
  @override
  DateTime get start => (origin as TrackMetricsProvider).start;
  @override
  DateTime get end => (origin as TrackMetricsProvider).end;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
