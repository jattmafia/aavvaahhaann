// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_mood.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheMoodAdapter extends TypeAdapter<CacheMood> {
  @override
  final int typeId = 8;

  @override
  CacheMood read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheMood(
      mood: fields[0] as Mood,
      tracks: (fields[1] as List).cast<Track>(),
    );
  }

  @override
  void write(BinaryWriter writer, CacheMood obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.mood)
      ..writeByte(1)
      ..write(obj.tracks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheMoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
