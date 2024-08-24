// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessionuser_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionUserNotifierHash() =>
    r'ee94bcaed8fdc8a7b74a0d2b2615b0276fe52de4';

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

abstract class _$SessionUserNotifier
    extends BuildlessAutoDisposeNotifier<AdminProfilesState> {
  late final List<dynamic> data;

  AdminProfilesState build(
    List<dynamic> data,
  );
}

/// See also [SessionUserNotifier].
@ProviderFor(SessionUserNotifier)
const sessionUserNotifierProvider = SessionUserNotifierFamily();

/// See also [SessionUserNotifier].
class SessionUserNotifierFamily extends Family<AdminProfilesState> {
  /// See also [SessionUserNotifier].
  const SessionUserNotifierFamily();

  /// See also [SessionUserNotifier].
  SessionUserNotifierProvider call(
    List<dynamic> data,
  ) {
    return SessionUserNotifierProvider(
      data,
    );
  }

  @override
  SessionUserNotifierProvider getProviderOverride(
    covariant SessionUserNotifierProvider provider,
  ) {
    return call(
      provider.data,
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
  String? get name => r'sessionUserNotifierProvider';
}

/// See also [SessionUserNotifier].
class SessionUserNotifierProvider extends AutoDisposeNotifierProviderImpl<
    SessionUserNotifier, AdminProfilesState> {
  /// See also [SessionUserNotifier].
  SessionUserNotifierProvider(
    List<dynamic> data,
  ) : this._internal(
          () => SessionUserNotifier()..data = data,
          from: sessionUserNotifierProvider,
          name: r'sessionUserNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionUserNotifierHash,
          dependencies: SessionUserNotifierFamily._dependencies,
          allTransitiveDependencies:
              SessionUserNotifierFamily._allTransitiveDependencies,
          data: data,
        );

  SessionUserNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.data,
  }) : super.internal();

  final List<dynamic> data;

  @override
  AdminProfilesState runNotifierBuild(
    covariant SessionUserNotifier notifier,
  ) {
    return notifier.build(
      data,
    );
  }

  @override
  Override overrideWith(SessionUserNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SessionUserNotifierProvider._internal(
        () => create()..data = data,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        data: data,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SessionUserNotifier, AdminProfilesState>
      createElement() {
    return _SessionUserNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionUserNotifierProvider && other.data == data;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, data.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SessionUserNotifierRef
    on AutoDisposeNotifierProviderRef<AdminProfilesState> {
  /// The parameter `data` of this provider.
  List<dynamic> get data;
}

class _SessionUserNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<SessionUserNotifier,
        AdminProfilesState> with SessionUserNotifierRef {
  _SessionUserNotifierProviderElement(super.provider);

  @override
  List<dynamic> get data => (origin as SessionUserNotifierProvider).data;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
