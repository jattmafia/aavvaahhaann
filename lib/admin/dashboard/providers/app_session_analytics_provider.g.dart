// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_session_analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appSessionAnalyticsHash() =>
    r'dfbf1b0252563b51ff3eaa0cb0e4b1e17d9d6db6';

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

/// See also [appSessionAnalytics].
@ProviderFor(appSessionAnalytics)
const appSessionAnalyticsProvider = AppSessionAnalyticsFamily();

/// See also [appSessionAnalytics].
class AppSessionAnalyticsFamily
    extends Family<AsyncValue<AppSessionAnalytics>> {
  /// See also [appSessionAnalytics].
  const AppSessionAnalyticsFamily();

  /// See also [appSessionAnalytics].
  AppSessionAnalyticsProvider call(
    DateTime startDate,
    DateTime endDate,
  ) {
    return AppSessionAnalyticsProvider(
      startDate,
      endDate,
    );
  }

  @override
  AppSessionAnalyticsProvider getProviderOverride(
    covariant AppSessionAnalyticsProvider provider,
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
  String? get name => r'appSessionAnalyticsProvider';
}

/// See also [appSessionAnalytics].
class AppSessionAnalyticsProvider extends FutureProvider<AppSessionAnalytics> {
  /// See also [appSessionAnalytics].
  AppSessionAnalyticsProvider(
    DateTime startDate,
    DateTime endDate,
  ) : this._internal(
          (ref) => appSessionAnalytics(
            ref as AppSessionAnalyticsRef,
            startDate,
            endDate,
          ),
          from: appSessionAnalyticsProvider,
          name: r'appSessionAnalyticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$appSessionAnalyticsHash,
          dependencies: AppSessionAnalyticsFamily._dependencies,
          allTransitiveDependencies:
              AppSessionAnalyticsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  AppSessionAnalyticsProvider._internal(
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
    FutureOr<AppSessionAnalytics> Function(AppSessionAnalyticsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AppSessionAnalyticsProvider._internal(
        (ref) => create(ref as AppSessionAnalyticsRef),
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
  FutureProviderElement<AppSessionAnalytics> createElement() {
    return _AppSessionAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppSessionAnalyticsProvider &&
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

mixin AppSessionAnalyticsRef on FutureProviderRef<AppSessionAnalytics> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _AppSessionAnalyticsProviderElement
    extends FutureProviderElement<AppSessionAnalytics>
    with AppSessionAnalyticsRef {
  _AppSessionAnalyticsProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as AppSessionAnalyticsProvider).startDate;
  @override
  DateTime get endDate => (origin as AppSessionAnalyticsProvider).endDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
