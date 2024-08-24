import 'dart:convert';

import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/config.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:avahan/features/artists/providers/artists_provider.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive/hive.dart';

part 'track.g.dart';

@HiveType(typeId: 4)
class Track extends HiveObject {
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
  final String url;
  @HiveField(11)
  final List<int> artists;
  @HiveField(12)
  final List<int> categories;
  @HiveField(13)
  final List<int> moods;
  @HiveField(14)
  final List<String> tags;
  @HiveField(15)
  final bool active;
  @HiveField(16)
  final String? lyricsEn;
  @HiveField(17)
  final String? lyricsHi;
  @HiveField(18)
  final DateTime? updatedAt;
  @HiveField(19)
  final int? createdBy;
  @HiveField(20)
  final int? updatedBy;
  @HiveField(21)
  final String? fileType;
  @HiveField(22)
  final int? fileSize;
  @HiveField(23)
  final String? groupId;
  @HiveField(24)
  final int? groupIndex;
  @HiveField(25)
  final List<String>? links;

  final int? duration;

  Track({
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
    required this.url,
    this.artists = const [],
    this.categories = const [],
    this.moods = const [],
    this.tags = const [],
    this.lyricsEn,
    this.lyricsHi,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.fileType,
    this.fileSize,
    this.groupId,
    this.groupIndex,
    this.links,
    this.duration,
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
      'url': url,
      'artists': artists,
      'categories': categories,
      'moods': moods,
      'tags': tags,
      'lyricsEn': lyricsEn,
      'lyricsHi': lyricsHi,
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'fileType': fileType,
      'fileSize': fileSize,
      'groupId': groupId,
      'groupIndex': groupIndex,
      'links': links,
      'searchKey': [
        nameEn,
        nameHi,
        ...tags,
      ].where((element) => element != null).join(' '),
      'duration': duration,
    };
  }

  List<Artist> artistsList(WidgetRef ref) => (Config.isAdmin
          ? ref.read(adminArtistsNotifierProvider).artists
          : ref.read(artistsProvider).asData?.value ?? [])
      .where((element) => artists.contains(element.id))
      .toList();

  List<Artist> artistsListRef(Ref ref) => (Config.isAdmin
          ? ref.read(adminArtistsNotifierProvider).artists
          : ref.read(artistsProvider).asData?.value ?? [])
      .where((element) => artists.contains(element.id))
      .toList();

  String artistsLabel(WidgetRef ref, Lang lang) =>
      artistsList(ref).map((e) => e.name(lang)).join(", ");

  String artistsLabelRef(Ref ref, Lang lang) =>
      artistsListRef(ref).map((e) => e.name(lang)).join(", ");

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] as int,
      createdAt: DateTime.parse(map['createdAt']),
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
      lyricsEn: map['lyricsEn'] != null ? map['lyricsEn'] as String : null,
      lyricsHi: map['lyricsHi'] != null ? map['lyricsHi'] as String : null,
      active: map['active'] as bool,
      url: map['url'] as String,
      artists: map['artists'] != null
          ? List<int>.from(map['artists'] as List<dynamic>)
          : [],
      categories: map['categories'] != null
          ? List<int>.from(map['categories'] as List<dynamic>)
          : [],
      moods: map['moods'] != null
          ? List<int>.from(map['moods'] as List<dynamic>)
          : [],
      tags: map['tags'] != null
          ? List<String>.from(map['tags'] as List<dynamic>)
          : [],
      createdBy: map['createdBy'] as int?,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      updatedBy: map['updatedBy'] as int?,
      fileType: map['fileType'] as String?,
      fileSize: map['fileSize'] as int?,
      groupId: map['groupId'] as String?,
      groupIndex: map['groupIndex'] as int?,
      links: map['links'] != null
          ? List<String>.from(map['links'] as List<dynamic>)
          : null,
      duration: map['duration'] as int?,
    );
  }

  Track copyWith({
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
    String? url,
    List<int>? artists,
    List<int>? categories,
    List<int>? moods,
    List<String>? tags,
    String? lyricsEn,
    String? lyricsHi,
    DateTime? updatedAt,
    int? createdBy,
    int? updatedBy,
    String? fileType,
    int? fileSize,
    String? groupId,
    int? groupIndex,
    bool clearGroupId = false,
    bool clearGroupIndex = false,
    List<String>? links,
    int? duration,
  }) {
    return Track(
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
      url: url ?? this.url,
      artists: artists ?? this.artists,
      categories: categories ?? this.categories,
      moods: moods ?? this.moods,
      tags: tags ?? this.tags,
      lyricsEn: lyricsEn ?? this.lyricsEn,
      lyricsHi: lyricsHi ?? this.lyricsHi,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      groupId: clearGroupId ? null : groupId ?? this.groupId,
      groupIndex: clearGroupIndex ? null : groupIndex ?? this.groupIndex,
      links: links ?? this.links,
      duration: duration ?? this.duration,
    );
  }

  Track clearEmpty() {
    return Track(
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
      url: url,
      artists: artists,
      categories: categories,
      moods: moods,
      tags: tags,
      lyricsEn: lyricsEn?.crim,
      lyricsHi: lyricsHi?.crim,
      createdBy: createdBy,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      fileType: fileType,
      fileSize: fileSize,
      groupId: groupId,
      groupIndex: groupIndex,
      links: links,
      duration: duration,
    );
  }

  //   factory MusicCategory.empty() {
  //   return MusicCategory(
  //     id: 0,
  //     createdAt: DateTime.now(),
  //     nameEn: '',
  //     iconEn: '',
  //     coverEn: '',
  //     active: false,
  //   );
  // }

  //   factory Mood.empty() {
  //   return Mood(
  //     id: 0,
  //     createdAt: DateTime.now(),
  //     nameEn: '',
  //     iconEn: '',
  //     coverEn: '',
  //   );
  // }
  factory Track.empty() {
    return Track(
      id: 0,
      createdAt: DateTime.now(),
      nameEn: '',
      iconEn: '',
      coverEn: null,
      active: false,
      url: '',
    );
  }

  String name([Lang? lang]) {
    final value = switch (lang) {
      Lang.en => nameEn,
      Lang.hi => nameHi ?? nameEn,
      _ => nameEn,
    };

    return [
      if (groupIndex != null) "$groupIndex.",
      value,
    ].join(' ');
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

  String? lyrics([Lang? lang]) {
    return switch (lang) {
      Lang.en => lyricsEn,
      Lang.hi => lyricsHi ?? lyricsEn,
      _ => lyricsEn,
    };
  }

  String? lyricsLang([Lang? lang]) {
    return switch (lang) {
      Lang.en => lyricsEn,
      Lang.hi => lyricsHi,
      _ => lyricsEn,
    };
  }

  String get searchString {
    return [
      nameEn,
      nameHi,
      descriptionEn,
      descriptionHi,
      lyricsEn,
      lyricsHi,
      tags.join(' '),
    ].where((element) => element != null).join(' ').toLowerCase();
  }

  String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) =>
      Track.fromMap(json.decode(source) as Map<String, dynamic>);
}
