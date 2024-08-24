// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_playlist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachePlaylistAdapter extends TypeAdapter<CachePlaylist> {
  @override
  final int typeId = 9;

  @override
  CachePlaylist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachePlaylist(
      playlist: fields[0] as Playlist,
      tracks: (fields[1] as List).cast<Track>(),
    );
  }

  @override
  void write(BinaryWriter writer, CachePlaylist obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.playlist)
      ..writeByte(1)
      ..write(obj.tracks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachePlaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
