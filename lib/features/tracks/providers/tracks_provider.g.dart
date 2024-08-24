// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tracksHash() => r'e5dab3c06b985533bb4a38ae732d983458c57a22';

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

/// See also [tracks].
@ProviderFor(tracks)
const tracksProvider = TracksFamily();

/// See also [tracks].
class TracksFamily extends Family<AsyncValue<List<Track>>> {
  /// See also [tracks].
  const TracksFamily();

  /// See also [tracks].
  TracksProvider call({
    int? categoryId,
    int? moodId,
    int? artistId,
    List<int>? ids,
    String? searchKey,
  }) {
    return TracksProvider(
      categoryId: categoryId,
      moodId: moodId,
      artistId: artistId,
      ids: ids,
      searchKey: searchKey,
    );
  }

  @override
  TracksProvider getProviderOverride(
    covariant TracksProvider provider,
  ) {
    return call(
      categoryId: provider.categoryId,
      moodId: provider.moodId,
      artistId: provider.artistId,
      ids: provider.ids,
      searchKey: provider.searchKey,
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
  String? get name => r'tracksProvider';
}

/// See also [tracks].
class TracksProvider extends AutoDisposeFutureProvider<List<Track>> {
  /// See also [tracks].
  TracksProvider({
    int? categoryId,
    int? moodId,
    int? artistId,
    List<int>? ids,
    String? searchKey,
  }) : this._internal(
          (ref) => tracks(
            ref as TracksRef,
            categoryId: categoryId,
            moodId: moodId,
            artistId: artistId,
            ids: ids,
            searchKey: searchKey,
          ),
          from: tracksProvider,
          name: r'tracksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tracksHash,
          dependencies: TracksFamily._dependencies,
          allTransitiveDependencies: TracksFamily._allTransitiveDependencies,
          categoryId: categoryId,
          moodId: moodId,
          artistId: artistId,
          ids: ids,
          searchKey: searchKey,
        );

  TracksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.moodId,
    required this.artistId,
    required this.ids,
    required this.searchKey,
  }) : super.internal();

  final int? categoryId;
  final int? moodId;
  final int? artistId;
  final List<int>? ids;
  final String? searchKey;

  @override
  Override overrideWith(
    FutureOr<List<Track>> Function(TracksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TracksProvider._internal(
        (ref) => create(ref as TracksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        moodId: moodId,
        artistId: artistId,
        ids: ids,
        searchKey: searchKey,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Track>> createElement() {
    return _TracksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TracksProvider &&
        other.categoryId == categoryId &&
        other.moodId == moodId &&
        other.artistId == artistId &&
        other.ids == ids &&
        other.searchKey == searchKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, moodId.hashCode);
    hash = _SystemHash.combine(hash, artistId.hashCode);
    hash = _SystemHash.combine(hash, ids.hashCode);
    hash = _SystemHash.combine(hash, searchKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TracksRef on AutoDisposeFutureProviderRef<List<Track>> {
  /// The parameter `categoryId` of this provider.
  int? get categoryId;

  /// The parameter `moodId` of this provider.
  int? get moodId;

  /// The parameter `artistId` of this provider.
  int? get artistId;

  /// The parameter `ids` of this provider.
  List<int>? get ids;

  /// The parameter `searchKey` of this provider.
  String? get searchKey;
}

class _TracksProviderElement
    extends AutoDisposeFutureProviderElement<List<Track>> with TracksRef {
  _TracksProviderElement(super.provider);

  @override
  int? get categoryId => (origin as TracksProvider).categoryId;
  @override
  int? get moodId => (origin as TracksProvider).moodId;
  @override
  int? get artistId => (origin as TracksProvider).artistId;
  @override
  List<int>? get ids => (origin as TracksProvider).ids;
  @override
  String? get searchKey => (origin as TracksProvider).searchKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
