// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheMusicCategoryAdapter extends TypeAdapter<CacheMusicCategory> {
  @override
  final int typeId = 7;

  @override
  CacheMusicCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheMusicCategory(
      category: fields[0] as MusicCategory,
      tracks: (fields[1] as List).cast<Track>(),
    );
  }

  @override
  void write(BinaryWriter writer, CacheMusicCategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.tracks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheMusicCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
