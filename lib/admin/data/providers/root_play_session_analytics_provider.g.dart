// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_play_session_analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rootPlaySessionMetricsHash() =>
    r'432b9afa53b0a6f957bece19386570f384c72646';

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

/// See also [rootPlaySessionMetrics].
@ProviderFor(rootPlaySessionMetrics)
const rootPlaySessionMetricsProvider = RootPlaySessionMetricsFamily();

/// See also [rootPlaySessionMetrics].
class RootPlaySessionMetricsFamily
    extends Family<AsyncValue<RootPlaySessionMetrics>> {
  /// See also [rootPlaySessionMetrics].
  const RootPlaySessionMetricsFamily();

  /// See also [rootPlaySessionMetrics].
  RootPlaySessionMetricsProvider call(
    int id,
    AvahanDataType type,
    DateTime start,
    DateTime end,
  ) {
    return RootPlaySessionMetricsProvider(
      id,
      type,
      start,
      end,
    );
  }

  @override
  RootPlaySessionMetricsProvider getProviderOverride(
    covariant RootPlaySessionMetricsProvider provider,
  ) {
    return call(
      provider.id,
      provider.type,
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
  String? get name => r'rootPlaySessionMetricsProvider';
}

/// See also [rootPlaySessionMetrics].
class RootPlaySessionMetricsProvider
    extends FutureProvider<RootPlaySessionMetrics> {
  /// See also [rootPlaySessionMetrics].
  RootPlaySessionMetricsProvider(
    int id,
    AvahanDataType type,
    DateTime start,
    DateTime end,
  ) : this._internal(
          (ref) => rootPlaySessionMetrics(
            ref as RootPlaySessionMetricsRef,
            id,
            type,
            start,
            end,
          ),
          from: rootPlaySessionMetricsProvider,
          name: r'rootPlaySessionMetricsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rootPlaySessionMetricsHash,
          dependencies: RootPlaySessionMetricsFamily._dependencies,
          allTransitiveDependencies:
              RootPlaySessionMetricsFamily._allTransitiveDependencies,
          id: id,
          type: type,
          start: start,
          end: end,
        );

  RootPlaySessionMetricsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.type,
    required this.start,
    required this.end,
  }) : super.internal();

  final int id;
  final AvahanDataType type;
  final DateTime start;
  final DateTime end;

  @override
  Override overrideWith(
    FutureOr<RootPlaySessionMetrics> Function(
            RootPlaySessionMetricsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RootPlaySessionMetricsProvider._internal(
        (ref) => create(ref as RootPlaySessionMetricsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        type: type,
        start: start,
        end: end,
      ),
    );
  }

  @override
  FutureProviderElement<RootPlaySessionMetrics> createElement() {
    return _RootPlaySessionMetricsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RootPlaySessionMetricsProvider &&
        other.id == id &&
        other.type == type &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, start.hashCode);
    hash = _SystemHash.combine(hash, end.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RootPlaySessionMetricsRef on FutureProviderRef<RootPlaySessionMetrics> {
  /// The parameter `id` of this provider.
  int get id;

  /// The parameter `type` of this provider.
  AvahanDataType get type;

  /// The parameter `start` of this provider.
  DateTime get start;

  /// The parameter `end` of this provider.
  DateTime get end;
}

class _RootPlaySessionMetricsProviderElement
    extends FutureProviderElement<RootPlaySessionMetrics>
    with RootPlaySessionMetricsRef {
  _RootPlaySessionMetricsProviderElement(super.provider);

  @override
  int get id => (origin as RootPlaySessionMetricsProvider).id;
  @override
  AvahanDataType get type => (origin as RootPlaySessionMetricsProvider).type;
  @override
  DateTime get start => (origin as RootPlaySessionMetricsProvider).start;
  @override
  DateTime get end => (origin as RootPlaySessionMetricsProvider).end;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
