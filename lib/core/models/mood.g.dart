// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoodAdapter extends TypeAdapter<Mood> {
  @override
  final int typeId = 1;

  @override
  Mood read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mood(
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
      updatedAt: fields[10] as DateTime?,
      createdBy: fields[11] as int?,
      updatedBy: fields[12] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Mood obj) {
    writer
      ..writeByte(13)
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
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.createdBy)
      ..writeByte(12)
      ..write(obj.updatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
