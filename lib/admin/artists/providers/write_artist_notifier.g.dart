// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'write_artist_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$writeArtistHash() => r'8187114808eec88f75fb689405d7a74de00a793a';

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

abstract class _$WriteArtist
    extends BuildlessAutoDisposeNotifier<WriteArtistState> {
  late final Artist? artist;

  WriteArtistState build(
    Artist? artist,
  );
}

/// See also [WriteArtist].
@ProviderFor(WriteArtist)
const writeArtistProvider = WriteArtistFamily();

/// See also [WriteArtist].
class WriteArtistFamily extends Family<WriteArtistState> {
  /// See also [WriteArtist].
  const WriteArtistFamily();

  /// See also [WriteArtist].
  WriteArtistProvider call(
    Artist? artist,
  ) {
    return WriteArtistProvider(
      artist,
    );
  }

  @override
  WriteArtistProvider getProviderOverride(
    covariant WriteArtistProvider provider,
  ) {
    return call(
      provider.artist,
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
  String? get name => r'writeArtistProvider';
}

/// See also [WriteArtist].
class WriteArtistProvider
    extends AutoDisposeNotifierProviderImpl<WriteArtist, WriteArtistState> {
  /// See also [WriteArtist].
  WriteArtistProvider(
    Artist? artist,
  ) : this._internal(
          () => WriteArtist()..artist = artist,
          from: writeArtistProvider,
          name: r'writeArtistProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$writeArtistHash,
          dependencies: WriteArtistFamily._dependencies,
          allTransitiveDependencies:
              WriteArtistFamily._allTransitiveDependencies,
          artist: artist,
        );

  WriteArtistProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.artist,
  }) : super.internal();

  final Artist? artist;

  @override
  WriteArtistState runNotifierBuild(
    covariant WriteArtist notifier,
  ) {
    return notifier.build(
      artist,
    );
  }

  @override
  Override overrideWith(WriteArtist Function() create) {
    return ProviderOverride(
      origin: this,
      override: WriteArtistProvider._internal(
        () => create()..artist = artist,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        artist: artist,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WriteArtist, WriteArtistState>
      createElement() {
    return _WriteArtistProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WriteArtistProvider && other.artist == artist;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, artist.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WriteArtistRef on AutoDisposeNotifierProviderRef<WriteArtistState> {
  /// The parameter `artist` of this provider.
  Artist? get artist;
}

class _WriteArtistProviderElement
    extends AutoDisposeNotifierProviderElement<WriteArtist, WriteArtistState>
    with WriteArtistRef {
  _WriteArtistProviderElement(super.provider);

  @override
  Artist? get artist => (origin as WriteArtistProvider).artist;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
