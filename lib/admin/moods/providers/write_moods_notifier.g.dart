// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'write_moods_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$writeMoodHash() => r'09f2064785a0c39470c5a534f81098ca6576409f';

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

abstract class _$WriteMood
    extends BuildlessAutoDisposeNotifier<WriteMoodState> {
  late final Mood? moods;

  WriteMoodState build(
    Mood? moods,
  );
}

/// See also [WriteMood].
@ProviderFor(WriteMood)
const writeMoodProvider = WriteMoodFamily();

/// See also [WriteMood].
class WriteMoodFamily extends Family<WriteMoodState> {
  /// See also [WriteMood].
  const WriteMoodFamily();

  /// See also [WriteMood].
  WriteMoodProvider call(
    Mood? moods,
  ) {
    return WriteMoodProvider(
      moods,
    );
  }

  @override
  WriteMoodProvider getProviderOverride(
    covariant WriteMoodProvider provider,
  ) {
    return call(
      provider.moods,
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
  String? get name => r'writeMoodProvider';
}

/// See also [WriteMood].
class WriteMoodProvider
    extends AutoDisposeNotifierProviderImpl<WriteMood, WriteMoodState> {
  /// See also [WriteMood].
  WriteMoodProvider(
    Mood? moods,
  ) : this._internal(
          () => WriteMood()..moods = moods,
          from: writeMoodProvider,
          name: r'writeMoodProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$writeMoodHash,
          dependencies: WriteMoodFamily._dependencies,
          allTransitiveDependencies: WriteMoodFamily._allTransitiveDependencies,
          moods: moods,
        );

  WriteMoodProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.moods,
  }) : super.internal();

  final Mood? moods;

  @override
  WriteMoodState runNotifierBuild(
    covariant WriteMood notifier,
  ) {
    return notifier.build(
      moods,
    );
  }

  @override
  Override overrideWith(WriteMood Function() create) {
    return ProviderOverride(
      origin: this,
      override: WriteMoodProvider._internal(
        () => create()..moods = moods,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        moods: moods,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WriteMood, WriteMoodState>
      createElement() {
    return _WriteMoodProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WriteMoodProvider && other.moods == moods;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, moods.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WriteMoodRef on AutoDisposeNotifierProviderRef<WriteMoodState> {
  /// The parameter `moods` of this provider.
  Mood? get moods;
}

class _WriteMoodProviderElement
    extends AutoDisposeNotifierProviderElement<WriteMood, WriteMoodState>
    with WriteMoodRef {
  _WriteMoodProviderElement(super.provider);

  @override
  Mood? get moods => (origin as WriteMoodProvider).moods;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
