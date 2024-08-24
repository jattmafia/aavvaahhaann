import 'dart:convert';

import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/core/enums/artist_type.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive/hive.dart';

part 'artist.g.dart';

@HiveType(typeId: 11)
class Artist {
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
  final List<int> categories;
  @HiveField(12)
  final ArtistType type;
  @HiveField(13)
  final DateTime? updatedAt;
  @HiveField(14)
  final int? createdBy;
  @HiveField(15)
  final int? updatedBy;

  Artist({
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
    required this.active,
    required this.categories,
    required this.type,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,

  });

  Artist copyWith({
    int? id,
    DateTime? createdAt,
    String? nameEn,
    String? nameHi,
    String? iconEn,
    String? iconHi,
    String? coverEn,
    String? coverHi,
    String? descriptionEn,
    String? descriptionHi,
    bool? active,
    List<int>? categories,
    ArtistType? type,
    bool clearCoverEn = false,
    bool clearCoverHi = false,
    bool clearIconEn = false,
    bool clearIconHi = false,
    DateTime? updatedAt,
    int? createdBy,
    int? updatedBy,
  }) {
    return Artist(
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
      categories: categories ?? this.categories,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }



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
      'categories': categories,
      'type': type.name,
       'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
       'updatedBy': updatedBy,
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
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
      active: map['active'] as bool,
      categories: List<int>.from(
          ((map['categories'] as Iterable).map((e) => e as int))),
      type: ArtistType.values.firstWhere(
        (element) => element.name == map['type'] as String,
        orElse: () => ArtistType.unknown,
      ),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String).toLocal()
          : null,
      createdBy: map['createdBy'] as int?,
      updatedBy: map['updatedBy'] as int?,
    );
  }

  factory Artist.empty() {
    return Artist(
      id: 0,
      createdAt: DateTime.now(),
      nameEn: '',
      iconEn: '',
      coverEn: null,
      active: false,
      categories: [],
      type: ArtistType.unknown,
    );
  }

  Artist clearEmpty() {
    return Artist(
      id: id,
      createdAt: createdAt,
      nameEn: nameEn,
      iconEn: iconEn,
      coverEn: coverEn,
      active: active,
      categories: categories,
      type: type,
      coverHi: coverHi?.crim,
      descriptionEn: descriptionEn?.crim,
      descriptionHi: descriptionHi?.crim,
      iconHi: iconHi?.crim,
      nameHi: nameHi?.crim,
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
      .where((element) => element.artists.contains(id))
      .length;

  

          String toJson() => json.encode(toMap());

  factory Artist.fromJson(String source) =>
      Artist.fromMap(json.decode(source) as Map<String, dynamic>);
}
