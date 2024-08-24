// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtistTypeAdapter extends TypeAdapter<ArtistType> {
  @override
  final int typeId = 12;

  @override
  ArtistType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ArtistType.singer;
      case 1:
        return ArtistType.composer;
      case 2:
        return ArtistType.lyricist;
      case 3:
        return ArtistType.astrologer;
      case 4:
        return ArtistType.pandit;
      case 5:
        return ArtistType.contributor;
      case 6:
        return ArtistType.soundEngineer;
      case 7:
        return ArtistType.team;
      case 8:
        return ArtistType.narrator;
      case 9:
        return ArtistType.author;
      case 10:
        return ArtistType.unknown;
      default:
        return ArtistType.singer;
    }
  }

  @override
  void write(BinaryWriter writer, ArtistType obj) {
    switch (obj) {
      case ArtistType.singer:
        writer.writeByte(0);
        break;
      case ArtistType.composer:
        writer.writeByte(1);
        break;
      case ArtistType.lyricist:
        writer.writeByte(2);
        break;
      case ArtistType.astrologer:
        writer.writeByte(3);
        break;
      case ArtistType.pandit:
        writer.writeByte(4);
        break;
      case ArtistType.contributor:
        writer.writeByte(5);
        break;
      case ArtistType.soundEngineer:
        writer.writeByte(6);
        break;
      case ArtistType.team:
        writer.writeByte(7);
        break;
      case ArtistType.narrator:
        writer.writeByte(8);
        break;
      case ArtistType.author:
        writer.writeByte(9);
        break;
      case ArtistType.unknown:
        writer.writeByte(10);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
