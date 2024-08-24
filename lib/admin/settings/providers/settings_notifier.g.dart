// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminSettingsNotifierHash() =>
    r'42c06d83bfffda2aee82373c92d546fe782f9f11';

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

abstract class _$AdminSettingsNotifier
    extends BuildlessAutoDisposeNotifier<AdminSettingsState> {
  late final MasterData masterData;

  AdminSettingsState build(
    MasterData masterData,
  );
}

/// See also [AdminSettingsNotifier].
@ProviderFor(AdminSettingsNotifier)
const adminSettingsNotifierProvider = AdminSettingsNotifierFamily();

/// See also [AdminSettingsNotifier].
class AdminSettingsNotifierFamily extends Family<AdminSettingsState> {
  /// See also [AdminSettingsNotifier].
  const AdminSettingsNotifierFamily();

  /// See also [AdminSettingsNotifier].
  AdminSettingsNotifierProvider call(
    MasterData masterData,
  ) {
    return AdminSettingsNotifierProvider(
      masterData,
    );
  }

  @override
  AdminSettingsNotifierProvider getProviderOverride(
    covariant AdminSettingsNotifierProvider provider,
  ) {
    return call(
      provider.masterData,
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
  String? get name => r'adminSettingsNotifierProvider';
}

/// See also [AdminSettingsNotifier].
class AdminSettingsNotifierProvider extends AutoDisposeNotifierProviderImpl<
    AdminSettingsNotifier, AdminSettingsState> {
  /// See also [AdminSettingsNotifier].
  AdminSettingsNotifierProvider(
    MasterData masterData,
  ) : this._internal(
          () => AdminSettingsNotifier()..masterData = masterData,
          from: adminSettingsNotifierProvider,
          name: r'adminSettingsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adminSettingsNotifierHash,
          dependencies: AdminSettingsNotifierFamily._dependencies,
          allTransitiveDependencies:
              AdminSettingsNotifierFamily._allTransitiveDependencies,
          masterData: masterData,
        );

  AdminSettingsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.masterData,
  }) : super.internal();

  final MasterData masterData;

  @override
  AdminSettingsState runNotifierBuild(
    covariant AdminSettingsNotifier notifier,
  ) {
    return notifier.build(
      masterData,
    );
  }

  @override
  Override overrideWith(AdminSettingsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AdminSettingsNotifierProvider._internal(
        () => create()..masterData = masterData,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        masterData: masterData,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AdminSettingsNotifier, AdminSettingsState>
      createElement() {
    return _AdminSettingsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminSettingsNotifierProvider &&
        other.masterData == masterData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, masterData.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AdminSettingsNotifierRef
    on AutoDisposeNotifierProviderRef<AdminSettingsState> {
  /// The parameter `masterData` of this provider.
  MasterData get masterData;
}

class _AdminSettingsNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<AdminSettingsNotifier,
        AdminSettingsState> with AdminSettingsNotifierRef {
  _AdminSettingsNotifierProviderElement(super.provider);

  @override
  MasterData get masterData =>
      (origin as AdminSettingsNotifierProvider).masterData;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
