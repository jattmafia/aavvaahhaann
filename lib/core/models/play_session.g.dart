// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaySessionAdapter extends TypeAdapter<PlaySession> {
  @override
  final int typeId = 13;

  @override
  PlaySession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaySession(
      id: fields[0] as int,
      userId: fields[1] as int,
      channel: fields[2] as String,
      startedAt: fields[3] as DateTime,
      endedAt: fields[5] as DateTime?,
      totalDuration: fields[6] as int,
      duration: fields[7] as int,
      trackId: fields[8] as int,
      rootType: fields[9] as AvahanDataType,
      rootId: fields[10] as int,
      timerStartedAt: fields[4] as DateTime?,
      syncNeeded: fields[11] as bool,
      country: fields[12] as String?,
      state: fields[13] as String?,
      city: fields[14] as String?,
      age: fields[16] as int?,
      gender: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlaySession obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.channel)
      ..writeByte(3)
      ..write(obj.startedAt)
      ..writeByte(4)
      ..write(obj.timerStartedAt)
      ..writeByte(5)
      ..write(obj.endedAt)
      ..writeByte(6)
      ..write(obj.totalDuration)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.trackId)
      ..writeByte(9)
      ..write(obj.rootType)
      ..writeByte(10)
      ..write(obj.rootId)
      ..writeByte(11)
      ..write(obj.syncNeeded)
      ..writeByte(12)
      ..write(obj.country)
      ..writeByte(13)
      ..write(obj.state)
      ..writeByte(14)
      ..write(obj.city)
      ..writeByte(15)
      ..write(obj.gender)
      ..writeByte(16)
      ..write(obj.age);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaySessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
