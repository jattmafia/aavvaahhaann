// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'write_track_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$writeTrackHash() => r'aa9dc0a9558fbc1771d9cc82f5d60af804327227';

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

abstract class _$WriteTrack
    extends BuildlessAutoDisposeNotifier<WriteTracksState> {
  late final Track? tracks;

  WriteTracksState build(
    Track? tracks,
  );
}

/// See also [WriteTrack].
@ProviderFor(WriteTrack)
const writeTrackProvider = WriteTrackFamily();

/// See also [WriteTrack].
class WriteTrackFamily extends Family<WriteTracksState> {
  /// See also [WriteTrack].
  const WriteTrackFamily();

  /// See also [WriteTrack].
  WriteTrackProvider call(
    Track? tracks,
  ) {
    return WriteTrackProvider(
      tracks,
    );
  }

  @override
  WriteTrackProvider getProviderOverride(
    covariant WriteTrackProvider provider,
  ) {
    return call(
      provider.tracks,
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
  String? get name => r'writeTrackProvider';
}

/// See also [WriteTrack].
class WriteTrackProvider
    extends AutoDisposeNotifierProviderImpl<WriteTrack, WriteTracksState> {
  /// See also [WriteTrack].
  WriteTrackProvider(
    Track? tracks,
  ) : this._internal(
          () => WriteTrack()..tracks = tracks,
          from: writeTrackProvider,
          name: r'writeTrackProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$writeTrackHash,
          dependencies: WriteTrackFamily._dependencies,
          allTransitiveDependencies:
              WriteTrackFamily._allTransitiveDependencies,
          tracks: tracks,
        );

  WriteTrackProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tracks,
  }) : super.internal();

  final Track? tracks;

  @override
  WriteTracksState runNotifierBuild(
    covariant WriteTrack notifier,
  ) {
    return notifier.build(
      tracks,
    );
  }

  @override
  Override overrideWith(WriteTrack Function() create) {
    return ProviderOverride(
      origin: this,
      override: WriteTrackProvider._internal(
        () => create()..tracks = tracks,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tracks: tracks,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WriteTrack, WriteTracksState>
      createElement() {
    return _WriteTrackProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WriteTrackProvider && other.tracks == tracks;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tracks.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WriteTrackRef on AutoDisposeNotifierProviderRef<WriteTracksState> {
  /// The parameter `tracks` of this provider.
  Track? get tracks;
}

class _WriteTrackProviderElement
    extends AutoDisposeNotifierProviderElement<WriteTrack, WriteTracksState>
    with WriteTrackRef {
  _WriteTrackProviderElement(super.provider);

  @override
  Track? get tracks => (origin as WriteTrackProvider).tracks;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
