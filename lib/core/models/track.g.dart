// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackAdapter extends TypeAdapter<Track> {
  @override
  final int typeId = 4;

  @override
  Track read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Track(
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
      active: fields[15] as bool,
      url: fields[10] as String,
      artists: (fields[11] as List).cast<int>(),
      categories: (fields[12] as List).cast<int>(),
      moods: (fields[13] as List).cast<int>(),
      tags: (fields[14] as List).cast<String>(),
      lyricsEn: fields[16] as String?,
      lyricsHi: fields[17] as String?,
      createdBy: fields[19] as int?,
      updatedAt: fields[18] as DateTime?,
      updatedBy: fields[20] as int?,
      fileType: fields[21] as String?,
      fileSize: fields[22] as int?,
      groupId: fields[23] as String?,
      groupIndex: fields[24] as int?,
      links: (fields[25] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Track obj) {
    writer
      ..writeByte(26)
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
      ..write(obj.url)
      ..writeByte(11)
      ..write(obj.artists)
      ..writeByte(12)
      ..write(obj.categories)
      ..writeByte(13)
      ..write(obj.moods)
      ..writeByte(14)
      ..write(obj.tags)
      ..writeByte(15)
      ..write(obj.active)
      ..writeByte(16)
      ..write(obj.lyricsEn)
      ..writeByte(17)
      ..write(obj.lyricsHi)
      ..writeByte(18)
      ..write(obj.updatedAt)
      ..writeByte(19)
      ..write(obj.createdBy)
      ..writeByte(20)
      ..write(obj.updatedBy)
      ..writeByte(21)
      ..write(obj.fileType)
      ..writeByte(22)
      ..write(obj.fileSize)
      ..writeByte(23)
      ..write(obj.groupId)
      ..writeByte(24)
      ..write(obj.groupIndex)
      ..writeByte(25)
      ..write(obj.links);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
