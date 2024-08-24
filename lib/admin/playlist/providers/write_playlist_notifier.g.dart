// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'write_playlist_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$writePlaylistHash() => r'85b612c314fefcf93b61e53c89c767784fcf0b30';

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

abstract class _$WritePlaylist
    extends BuildlessAutoDisposeNotifier<WritePlayListState> {
  late final Playlist? playlist;

  WritePlayListState build(
    Playlist? playlist,
  );
}

/// See also [WritePlaylist].
@ProviderFor(WritePlaylist)
const writePlaylistProvider = WritePlaylistFamily();

/// See also [WritePlaylist].
class WritePlaylistFamily extends Family<WritePlayListState> {
  /// See also [WritePlaylist].
  const WritePlaylistFamily();

  /// See also [WritePlaylist].
  WritePlaylistProvider call(
    Playlist? playlist,
  ) {
    return WritePlaylistProvider(
      playlist,
    );
  }

  @override
  WritePlaylistProvider getProviderOverride(
    covariant WritePlaylistProvider provider,
  ) {
    return call(
      provider.playlist,
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
  String? get name => r'writePlaylistProvider';
}

/// See also [WritePlaylist].
class WritePlaylistProvider
    extends AutoDisposeNotifierProviderImpl<WritePlaylist, WritePlayListState> {
  /// See also [WritePlaylist].
  WritePlaylistProvider(
    Playlist? playlist,
  ) : this._internal(
          () => WritePlaylist()..playlist = playlist,
          from: writePlaylistProvider,
          name: r'writePlaylistProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$writePlaylistHash,
          dependencies: WritePlaylistFamily._dependencies,
          allTransitiveDependencies:
              WritePlaylistFamily._allTransitiveDependencies,
          playlist: playlist,
        );

  WritePlaylistProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.playlist,
  }) : super.internal();

  final Playlist? playlist;

  @override
  WritePlayListState runNotifierBuild(
    covariant WritePlaylist notifier,
  ) {
    return notifier.build(
      playlist,
    );
  }

  @override
  Override overrideWith(WritePlaylist Function() create) {
    return ProviderOverride(
      origin: this,
      override: WritePlaylistProvider._internal(
        () => create()..playlist = playlist,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        playlist: playlist,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WritePlaylist, WritePlayListState>
      createElement() {
    return _WritePlaylistProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WritePlaylistProvider && other.playlist == playlist;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, playlist.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WritePlaylistRef on AutoDisposeNotifierProviderRef<WritePlayListState> {
  /// The parameter `playlist` of this provider.
  Playlist? get playlist;
}

class _WritePlaylistProviderElement extends AutoDisposeNotifierProviderElement<
    WritePlaylist, WritePlayListState> with WritePlaylistRef {
  _WritePlaylistProviderElement(super.provider);

  @override
  Playlist? get playlist => (origin as WritePlaylistProvider).playlist;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
