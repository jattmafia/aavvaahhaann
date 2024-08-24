import 'package:avahan/core/enums/library_item_type.dart';

class LibraryItem {
  final int id;
  final DateTime createdAt;
  final int createdBy;
  final LibraryItemType type;
  final int itemId;

  LibraryItem({
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.type,
    required this.itemId,
  });

  LibraryItem copyWith({
    int? id,
    DateTime? createdAt,
    int? createdBy,
    LibraryItemType? type,
    int? itemId,
  }) {
    return LibraryItem(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      type: type ?? this.type,
      itemId: itemId ?? this.itemId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
     if(id != 0) 'id': id,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'type': type.name,
      'itemId': itemId,
    };
  }

  factory LibraryItem.fromMap(Map<String, dynamic> map) {
    return LibraryItem(
      id: map['id'] as int,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      createdBy: map['createdBy'] as int,
      type: LibraryItemType.values.firstWhere(
        (element) => element.name == map['type'],
        orElse: () => LibraryItemType.unknown,
      ),
      itemId: map['itemId'] as int,
    );
  }
}
