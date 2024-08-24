// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_user_playlist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheUserPlaylistAdapter extends TypeAdapter<CacheUserPlaylist> {
  @override
  final int typeId = 10;

  @override
  CacheUserPlaylist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheUserPlaylist(
      playlist: fields[0] as UserPlaylist,
      tracks: (fields[1] as List).cast<Track>(),
    );
  }

  @override
  void write(BinaryWriter writer, CacheUserPlaylist obj) {
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
      other is CacheUserPlaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
