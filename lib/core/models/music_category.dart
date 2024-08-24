// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/utils/extensions.dart';

part 'music_category.g.dart';

@HiveType(typeId: 2)
class MusicCategory extends HiveObject with EquatableMixin {
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
  final bool active;
  @HiveField(11)
  final DateTime? updatedAt;
  @HiveField(12)
  final int? createdBy;
  @HiveField(13)
  final int? updatedBy;

  MusicCategory({
    required this.id,
    required this.createdAt,
    required this.nameEn,
    this.nameHi,
    required this.iconEn,
    this.iconHi,
    required this.coverEn,
    this.coverHi,
    this.descriptionEn,
    this.descriptionHi,
    required this.active,
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
      'active': active,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }

  factory MusicCategory.fromMap(Map<String, dynamic> map) {
    return MusicCategory(
      id: map['id'] as int,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      nameEn: map['nameEn'] as String,
      nameHi: map['nameHi'] != null ? map['nameHi'] as String : null,
      iconEn: map['iconEn'] as String,
      iconHi: map['iconHi'] != null ? map['iconHi'] as String : null,
      coverEn: (map['coverEn'] as String?)?.crim,
      coverHi: map['coverHi'] != null ? map['coverHi'] as String : null,
      descriptionEn:
          map['descriptionEn'] != null ? map['descriptionEn'] as String : null,
      descriptionHi:
          map['descriptionHi'] != null ? map['descriptionHi'] as String : null,
      active: map['active'] as bool,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt']).toUtc()
          : null,
      createdBy: map['createdBy'] != null ? map['createdBy'] as int : null,
      updatedBy: map['updatedBy'] != null ? map['updatedBy'] as int : null,
    );
  }

  MusicCategory copyWith({
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
    return MusicCategory(
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
      active: active ?? this.active,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  MusicCategory clearEmpty() {
    return MusicCategory(
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
      active: active,
      createdBy: createdBy,
      updatedBy: updatedBy,
      updatedAt: updatedAt,
    );
  }

  factory MusicCategory.empty() {
    return MusicCategory(
      id: 0,
      createdAt: DateTime.now(),
      nameEn: '',
      iconEn: '',
      coverEn: null,
      active: false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        nameEn,
        nameHi,
        iconEn,
        iconHi,
        coverEn,
        coverHi,
        descriptionEn,
        descriptionHi,
        active,
      ];

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
      .where((element) => element.categories.contains(id))
      .length;

  String toJson() => json.encode(toMap());

  factory MusicCategory.fromJson(String source) =>
      MusicCategory.fromMap(json.decode(source) as Map<String, dynamic>);
}
