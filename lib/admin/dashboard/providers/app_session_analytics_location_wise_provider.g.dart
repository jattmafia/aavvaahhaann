// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_session_analytics_location_wise_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appSessionAnalyticsLocationWiseHash() =>
    r'907e569b66ee1f0f3dd6d740f2b1a64b4d3d6b88';

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

/// See also [appSessionAnalyticsLocationWise].
@ProviderFor(appSessionAnalyticsLocationWise)
const appSessionAnalyticsLocationWiseProvider =
    AppSessionAnalyticsLocationWiseFamily();

/// See also [appSessionAnalyticsLocationWise].
class AppSessionAnalyticsLocationWiseFamily
    extends Family<AsyncValue<List<AppSessionAnalytics>>> {
  /// See also [appSessionAnalyticsLocationWise].
  const AppSessionAnalyticsLocationWiseFamily();

  /// See also [appSessionAnalyticsLocationWise].
  AppSessionAnalyticsLocationWiseProvider call(
    DateTime startDate,
    DateTime endDate,
  ) {
    return AppSessionAnalyticsLocationWiseProvider(
      startDate,
      endDate,
    );
  }

  @override
  AppSessionAnalyticsLocationWiseProvider getProviderOverride(
    covariant AppSessionAnalyticsLocationWiseProvider provider,
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
  String? get name => r'appSessionAnalyticsLocationWiseProvider';
}

/// See also [appSessionAnalyticsLocationWise].
class AppSessionAnalyticsLocationWiseProvider
    extends FutureProvider<List<AppSessionAnalytics>> {
  /// See also [appSessionAnalyticsLocationWise].
  AppSessionAnalyticsLocationWiseProvider(
    DateTime startDate,
    DateTime endDate,
  ) : this._internal(
          (ref) => appSessionAnalyticsLocationWise(
            ref as AppSessionAnalyticsLocationWiseRef,
            startDate,
            endDate,
          ),
          from: appSessionAnalyticsLocationWiseProvider,
          name: r'appSessionAnalyticsLocationWiseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$appSessionAnalyticsLocationWiseHash,
          dependencies: AppSessionAnalyticsLocationWiseFamily._dependencies,
          allTransitiveDependencies:
              AppSessionAnalyticsLocationWiseFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  AppSessionAnalyticsLocationWiseProvider._internal(
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
    FutureOr<List<AppSessionAnalytics>> Function(
            AppSessionAnalyticsLocationWiseRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AppSessionAnalyticsLocationWiseProvider._internal(
        (ref) => create(ref as AppSessionAnalyticsLocationWiseRef),
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
  FutureProviderElement<List<AppSessionAnalytics>> createElement() {
    return _AppSessionAnalyticsLocationWiseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppSessionAnalyticsLocationWiseProvider &&
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

mixin AppSessionAnalyticsLocationWiseRef
    on FutureProviderRef<List<AppSessionAnalytics>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _AppSessionAnalyticsLocationWiseProviderElement
    extends FutureProviderElement<List<AppSessionAnalytics>>
    with AppSessionAnalyticsLocationWiseRef {
  _AppSessionAnalyticsLocationWiseProviderElement(super.provider);

  @override
  DateTime get startDate =>
      (origin as AppSessionAnalyticsLocationWiseProvider).startDate;
  @override
  DateTime get endDate =>
      (origin as AppSessionAnalyticsLocationWiseProvider).endDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
