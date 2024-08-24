// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSessionAdapter extends TypeAdapter<AppSession> {
  @override
  final int typeId = 16;

  @override
  AppSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSession(
      id: fields[0] as int,
      userId: fields[1] as int?,
      channel: fields[2] as String,
      createdAt: fields[3] as DateTime,
      endedAt: fields[4] as DateTime?,
      country: fields[5] as String?,
      state: fields[6] as String?,
      age: fields[9] as int?,
      city: fields[7] as String?,
      gender: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSession obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.channel)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.endedAt)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.state)
      ..writeByte(7)
      ..write(obj.city)
      ..writeByte(8)
      ..write(obj.gender)
      ..writeByte(9)
      ..write(obj.age);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
