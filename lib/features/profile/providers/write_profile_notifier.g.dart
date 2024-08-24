// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'write_profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$writeProfileHash() => r'45c4b7767f8c90a46897bf3c1e9df5f7110f2499';

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

abstract class _$WriteProfile
    extends BuildlessAutoDisposeNotifier<WriteProfileState> {
  late final Profile? profile;

  WriteProfileState build(
    Profile? profile,
  );
}

/// See also [WriteProfile].
@ProviderFor(WriteProfile)
const writeProfileProvider = WriteProfileFamily();

/// See also [WriteProfile].
class WriteProfileFamily extends Family<WriteProfileState> {
  /// See also [WriteProfile].
  const WriteProfileFamily();

  /// See also [WriteProfile].
  WriteProfileProvider call(
    Profile? profile,
  ) {
    return WriteProfileProvider(
      profile,
    );
  }

  @override
  WriteProfileProvider getProviderOverride(
    covariant WriteProfileProvider provider,
  ) {
    return call(
      provider.profile,
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
  String? get name => r'writeProfileProvider';
}

/// See also [WriteProfile].
class WriteProfileProvider
    extends AutoDisposeNotifierProviderImpl<WriteProfile, WriteProfileState> {
  /// See also [WriteProfile].
  WriteProfileProvider(
    Profile? profile,
  ) : this._internal(
          () => WriteProfile()..profile = profile,
          from: writeProfileProvider,
          name: r'writeProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$writeProfileHash,
          dependencies: WriteProfileFamily._dependencies,
          allTransitiveDependencies:
              WriteProfileFamily._allTransitiveDependencies,
          profile: profile,
        );

  WriteProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profile,
  }) : super.internal();

  final Profile? profile;

  @override
  WriteProfileState runNotifierBuild(
    covariant WriteProfile notifier,
  ) {
    return notifier.build(
      profile,
    );
  }

  @override
  Override overrideWith(WriteProfile Function() create) {
    return ProviderOverride(
      origin: this,
      override: WriteProfileProvider._internal(
        () => create()..profile = profile,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profile: profile,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WriteProfile, WriteProfileState>
      createElement() {
    return _WriteProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WriteProfileProvider && other.profile == profile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profile.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WriteProfileRef on AutoDisposeNotifierProviderRef<WriteProfileState> {
  /// The parameter `profile` of this provider.
  Profile? get profile;
}

class _WriteProfileProviderElement
    extends AutoDisposeNotifierProviderElement<WriteProfile, WriteProfileState>
    with WriteProfileRef {
  _WriteProfileProviderElement(super.provider);

  @override
  Profile? get profile => (origin as WriteProfileProvider).profile;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
