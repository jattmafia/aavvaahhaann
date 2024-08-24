// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'write_category_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$writeCategoryHash() => r'b282f922e07fc0064e6626e9ab020a23a441400e';

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

abstract class _$WriteCategory
    extends BuildlessAutoDisposeNotifier<WriteCategoryState> {
  late final MusicCategory? category;

  WriteCategoryState build(
    MusicCategory? category,
  );
}

/// See also [WriteCategory].
@ProviderFor(WriteCategory)
const writeCategoryProvider = WriteCategoryFamily();

/// See also [WriteCategory].
class WriteCategoryFamily extends Family<WriteCategoryState> {
  /// See also [WriteCategory].
  const WriteCategoryFamily();

  /// See also [WriteCategory].
  WriteCategoryProvider call(
    MusicCategory? category,
  ) {
    return WriteCategoryProvider(
      category,
    );
  }

  @override
  WriteCategoryProvider getProviderOverride(
    covariant WriteCategoryProvider provider,
  ) {
    return call(
      provider.category,
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
  String? get name => r'writeCategoryProvider';
}

/// See also [WriteCategory].
class WriteCategoryProvider
    extends AutoDisposeNotifierProviderImpl<WriteCategory, WriteCategoryState> {
  /// See also [WriteCategory].
  WriteCategoryProvider(
    MusicCategory? category,
  ) : this._internal(
          () => WriteCategory()..category = category,
          from: writeCategoryProvider,
          name: r'writeCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$writeCategoryHash,
          dependencies: WriteCategoryFamily._dependencies,
          allTransitiveDependencies:
              WriteCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  WriteCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final MusicCategory? category;

  @override
  WriteCategoryState runNotifierBuild(
    covariant WriteCategory notifier,
  ) {
    return notifier.build(
      category,
    );
  }

  @override
  Override overrideWith(WriteCategory Function() create) {
    return ProviderOverride(
      origin: this,
      override: WriteCategoryProvider._internal(
        () => create()..category = category,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WriteCategory, WriteCategoryState>
      createElement() {
    return _WriteCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WriteCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WriteCategoryRef on AutoDisposeNotifierProviderRef<WriteCategoryState> {
  /// The parameter `category` of this provider.
  MusicCategory? get category;
}

class _WriteCategoryProviderElement extends AutoDisposeNotifierProviderElement<
    WriteCategory, WriteCategoryState> with WriteCategoryRef {
  _WriteCategoryProviderElement(super.provider);

  @override
  MusicCategory? get category => (origin as WriteCategoryProvider).category;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
