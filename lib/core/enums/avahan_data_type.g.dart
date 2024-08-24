// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avahan_data_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AvahanDataTypeAdapter extends TypeAdapter<AvahanDataType> {
  @override
  final int typeId = 14;

  @override
  AvahanDataType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AvahanDataType.track;
      case 1:
        return AvahanDataType.artist;
      case 2:
        return AvahanDataType.playlist;
      case 3:
        return AvahanDataType.category;
      case 4:
        return AvahanDataType.mood;
      case 5:
        return AvahanDataType.unknown;
      default:
        return AvahanDataType.track;
    }
  }

  @override
  void write(BinaryWriter writer, AvahanDataType obj) {
    switch (obj) {
      case AvahanDataType.track:
        writer.writeByte(0);
        break;
      case AvahanDataType.artist:
        writer.writeByte(1);
        break;
      case AvahanDataType.playlist:
        writer.writeByte(2);
        break;
      case AvahanDataType.category:
        writer.writeByte(3);
        break;
      case AvahanDataType.mood:
        writer.writeByte(4);
        break;
      case AvahanDataType.unknown:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvahanDataTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
