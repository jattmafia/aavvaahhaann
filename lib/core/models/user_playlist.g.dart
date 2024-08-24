// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_playlist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPlaylistAdapter extends TypeAdapter<UserPlaylist> {
  @override
  final int typeId = 5;

  @override
  UserPlaylist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPlaylist(
      id: fields[0] as int,
      createdAt: fields[1] as DateTime,
      createdBy: fields[2] as int,
      name: fields[3] as String,
      tracks: (fields[4] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserPlaylist obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.createdBy)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.tracks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPlaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
