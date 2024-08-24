// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'mood.g.dart';

@HiveType(typeId: 1)
class Mood extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final DateTime createdAt;
  @HiveField(2)
  final String nameEn;
  @HiveField(3)
  final String? nameHi;
  @HiveField(4)
  final String iconEn;
  @HiveField(5)
  final String? iconHi;
  @HiveField(6)
  final String? coverEn;
  @HiveField(7)
  final String? coverHi;
  @HiveField(8)
  final String? descriptionEn;
  @HiveField(9)
  final String? descriptionHi;
  @HiveField(10)
  final DateTime? updatedAt;
  @HiveField(11)
  final int? createdBy;
  @HiveField(12)
  final int? updatedBy;

  Mood({
    required this.id,
    required this.createdAt,
    required this.nameEn,
    this.nameHi,
    required this.iconEn,
    this.iconHi,
    this.coverEn,
    this.coverHi,
    this.descriptionEn,
    this.descriptionHi,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != 0) 'id': id,
      'createdAt': createdAt.toIso8601String(),
      'nameEn': nameEn,
      'nameHi': nameHi,
      'iconEn': iconEn,
      'iconHi': iconHi,
      'coverEn': coverEn,
      'coverHi': coverHi,
      'descriptionEn': descriptionEn,
      'descriptionHi': descriptionHi,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }

  factory Mood.fromMap(Map<String, dynamic> map) {
    return Mood(
      id: map['id'] as int,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      nameEn: map['nameEn'] as String,
      nameHi: map['nameHi'] != null ? map['nameHi'] as String : null,
      iconEn: map['iconEn'] as String,
      iconHi: map['iconHi'] != null ? map['iconHi'] as String : null,
      coverEn: map['coverEn'] as String?,
      coverHi: map['coverHi'] != null ? map['coverHi'] as String : null,
      descriptionEn:
          map['descriptionEn'] != null ? map['descriptionEn'] as String : null,
      descriptionHi:
          map['descriptionHi'] != null ? map['descriptionHi'] as String : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']).toUtc() : null,
      createdBy: map['createdBy'] != null ? map['createdBy'] as int : null,
      updatedBy: map['updatedBy'] != null ? map['updatedBy'] as int : null,
    );
  }

  Mood copyWith({
    int? id,
    DateTime? createdAt,
    String? nameEn,
    String? nameHi,
    String? iconEn,
    String? iconHi,
    bool clearIconEn = false,
    bool clearIconHi = false,
    String? coverEn,
    String? coverHi,
    bool clearCoverEn = false,
    bool clearCoverHi = false,
    String? descriptionEn,
    String? descriptionHi,
    bool? active,
    DateTime? updatedAt,
    int? createdBy,
    int? updatedBy,
  }) {
    return Mood(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      nameEn: nameEn ?? this.nameEn,
      nameHi: nameHi ?? this.nameHi,
      iconEn: clearIconEn ? '' : iconEn ?? this.iconEn,
      iconHi: clearIconHi ? null : iconHi ?? this.iconHi,
      coverEn: clearCoverEn ? null : coverEn ?? this.coverEn,
      coverHi: clearCoverHi ? null : coverHi ?? this.coverHi,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionHi: descriptionHi ?? this.descriptionHi,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  Mood clearEmpty() {
    return Mood(
      id: id,
      createdAt: createdAt,
      nameEn: nameEn,
      nameHi: nameHi?.crim,
      iconEn: iconEn,
      iconHi: iconHi?.crim,
      coverEn: coverEn,
      coverHi: coverHi?.crim,
      descriptionEn: descriptionEn?.crim,
      descriptionHi: descriptionHi?.crim,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
    );
  }

  String name([Lang? lang]) {
    return switch (lang) {
      Lang.en => nameEn,
      Lang.hi => nameHi ?? nameEn,
      _ => nameEn,
    };
  }

  String? nameLang([Lang? lang]) {
    return switch (lang) {
      Lang.en => nameEn,
      Lang.hi => nameHi,
      _ => nameEn,
    };
  }

  String icon([Lang? lang]) {
    return switch (lang) {
      Lang.en => iconEn,
      Lang.hi => iconHi ?? iconEn,
      _ => iconEn,
    };
  }

  String? iconLang([Lang? lang]) {
    return switch (lang) {
      Lang.en => iconEn,
      Lang.hi => iconHi,
      _ => iconEn,
    };
  }

  String cover([Lang? lang]) {
    return switch (lang) {
      Lang.en => coverEn ?? iconEn,
      Lang.hi => coverHi ?? coverEn ?? iconHi ?? iconEn,
      _ => coverEn ?? iconEn,
    };
  }

  //   factory Mood.empty(){
  //   return Mood(
  //     id: 0,
  //     createdAt: DateTime.now(),
  //     nameEn: '',
  //     iconEn: '',
  //     coverEn: '',
  //     active: false,
  //     categories: [],
  //     type: '',
  //   );
  // }
  factory Mood.empty() {
    return Mood(
      id: 0,
      createdAt: DateTime.now(),
      nameEn: '',
      iconEn: '',
      coverEn: null,
    );
  }

  String? coverLang([Lang? lang]) {
    return switch (lang) {
      Lang.en => coverEn,
      Lang.hi => coverHi,
      _ => coverEn,
    };
  }

  String? description([Lang? lang]) {
    return switch (lang) {
      Lang.en => descriptionEn,
      Lang.hi => descriptionHi ?? descriptionEn,
      _ => descriptionEn,
    };
  }

  String? descriptionLang([Lang? lang]) {
    return switch (lang) {
      Lang.en => descriptionEn,
      Lang.hi => descriptionHi,
      _ => descriptionEn,
    };
  }

  String get searchString {
    return [
      nameEn,
      nameHi,
      descriptionEn,
      descriptionHi,
    ].where((element) => element != null).join(' ').toLowerCase();
  }

  int tracksCount(WidgetRef ref) => ref
      .watch(adminTracksNotifierProvider)
      .results
      .where((element) => element.moods.contains(id))
      .length;

  String toJson() => json.encode(toMap());

  factory Mood.fromJson(String source) =>
      Mood.fromMap(json.decode(source) as Map<String, dynamic>);
}
