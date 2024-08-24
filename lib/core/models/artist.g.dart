// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtistAdapter extends TypeAdapter<Artist> {
  @override
  final int typeId = 11;

  @override
  Artist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Artist(
      id: fields[0] as int,
      createdAt: fields[1] as DateTime,
      nameEn: fields[2] as String,
      nameHi: fields[3] as String?,
      iconEn: fields[4] as String,
      iconHi: fields[5] as String?,
      coverEn: fields[6] as String?,
      coverHi: fields[7] as String?,
      descriptionEn: fields[8] as String?,
      descriptionHi: fields[9] as String?,
      active: fields[10] as bool,
      categories: (fields[11] as List).cast<int>(),
      type: fields[12] as ArtistType,
      updatedAt: fields[13] as DateTime?,
      createdBy: fields[14] as int?,
      updatedBy: fields[15] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Artist obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.nameEn)
      ..writeByte(3)
      ..write(obj.nameHi)
      ..writeByte(4)
      ..write(obj.iconEn)
      ..writeByte(5)
      ..write(obj.iconHi)
      ..writeByte(6)
      ..write(obj.coverEn)
      ..writeByte(7)
      ..write(obj.coverHi)
      ..writeByte(8)
      ..write(obj.descriptionEn)
      ..writeByte(9)
      ..write(obj.descriptionHi)
      ..writeByte(10)
      ..write(obj.active)
      ..writeByte(11)
      ..write(obj.categories)
      ..writeByte(12)
      ..write(obj.type)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.createdBy)
      ..writeByte(15)
      ..write(obj.updatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
