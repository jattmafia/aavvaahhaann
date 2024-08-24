// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/datetime_slot.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class AppBanner extends Equatable {
  final String image;
  final String? imageHi;
  final String? action;
  final XFile? file;
  final XFile? fileHi;
  final List<int>? ids;
  final String? link;
  final DateTimeSlot? dateTimeSlot;
  final bool active;
  final String? id;

  const AppBanner({
    required this.image,
    this.action,
    this.file,
    this.ids,
    this.link,
    this.dateTimeSlot,
    this.active = true,
    this.imageHi,
    this.fileHi,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'action': action,
      'ids': ids,
      'link': link,
      'dateTimeSlot': dateTimeSlot?.toMap(),
      'active': active,
      'imageHi': imageHi,
      'id': id,
    };
  }

  String imageUrl(Lang lang) => Lang.hi == lang? (imageHi?.crim ?? image) : image;

  factory AppBanner.fromMap(Map<String, dynamic> map) {
    print(map);
    return AppBanner(
      id: map['id'] as String?,
      image: map['image'] as String,
      action: map['action'] as String?,
      ids: map['ids'] != null ? List<int>.from(map['ids']) : null,
      link: map['link'] as String?,
      active: map['active'] as bool? ?? true,
      dateTimeSlot: map['dateTimeSlot'] != null ? DateTimeSlot.fromMap(map['dateTimeSlot']) : null,
      imageHi: map['imageHi'] as String?,
    );
  }

  @override
  List<Object?> get props => [image, action, file, link, ids, dateTimeSlot, active, imageHi, fileHi];

  AppBanner copyWith({
    String? image,
    String? action,
    XFile? file,
    String? link,
    List<int>? ids,
    bool? active,
    DateTimeSlot? dateTimeSlot,
    bool clearDateTimeSlot = false,
    String? imageHi,
    XFile? fileHi,
    bool clearFileHi = false,
    bool clearImageHi = false,
    String? id,
  }) {
    return AppBanner(
      id: id ?? this.id,
      image: image ?? this.image,
      action: action ?? this.action,
      file: file ?? this.file,
      link: link ?? this.link,
      ids: ids ?? this.ids,
      active: active ?? this.active,
      dateTimeSlot: clearDateTimeSlot ? null : dateTimeSlot ?? this.dateTimeSlot,
      imageHi: clearImageHi? null: imageHi ?? this.imageHi,
      fileHi: clearFileHi ? null : fileHi ?? this.fileHi,
    );
  }
}
