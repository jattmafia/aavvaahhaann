// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_artist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheArtistAdapter extends TypeAdapter<CacheArtist> {
  @override
  final int typeId = 6;

  @override
  CacheArtist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheArtist(
      artist: fields[0] as Artist,
      tracks: (fields[1] as List).cast<Track>(),
    );
  }

  @override
  void write(BinaryWriter writer, CacheArtist obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.artist)
      ..writeByte(1)
      ..write(obj.tracks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheArtistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
