// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchHistoryItemAdapter extends TypeAdapter<SearchHistoryItem> {
  @override
  final int typeId = 15;

  @override
  SearchHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchHistoryItem(
      type: fields[0] as AvahanDataType,
      createdAt: fields[1] as DateTime,
      data: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SearchHistoryItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
