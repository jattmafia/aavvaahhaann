import 'dart:convert';

import 'package:avahan/core/enums/lang.dart';
import 'package:equatable/equatable.dart';

class PagesData extends Equatable {
  final int id;
  final String tcEn;
  final String? tcHi;
  final String privacyEn;
  final String? privacyHi;
  final String aboutEn;
  final String? aboutHi;

  const PagesData({
    required this.tcEn,
     this.tcHi,
    required this.privacyEn,
     this.privacyHi,
    required this.id,
    required this.aboutEn,
     this.aboutHi,
     
  });

  PagesData copyWith({
    String? tcEn,
    String? tcHi,
    String? privacyEn,
    String? privacyHi,
    int? id,
    String? aboutEn,
    String? aboutHi,
  }) {
    return PagesData(
      tcEn: tcEn ?? this.tcEn,
      tcHi: tcHi ?? this.tcHi,
      privacyEn: privacyEn ?? this.privacyEn,
      privacyHi: privacyHi ?? this.privacyHi,
      id: id ?? this.id,
      aboutEn: aboutEn ?? this.aboutEn,
      aboutHi: aboutHi ?? this.aboutHi,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tcEn': tcEn,
      'tcHi': tcHi,
      'privacyEn': privacyEn,
      'privacyHi': privacyHi,
      'id': id,
      'aboutEn': aboutEn,
      'aboutHi': aboutHi,
    };
  }

  factory PagesData.fromMap(Map<String, dynamic> map) {
    return PagesData(
      tcEn: map['tcEn'] as String? ?? '',
      tcHi: map['tcHi'] as String?,
      privacyEn: map['privacyEn'] as String? ?? '',
      privacyHi: map['privacyHi'] as String?,
      id: map['id'] as int,
      aboutEn: map['aboutEn'] as String? ?? '',
      aboutHi: map['aboutHi'] as String?,
    );
  }

  @override
  List<Object?> get props => [tcEn, tcHi, privacyEn, privacyHi, id, aboutEn, aboutHi];

  String tc([Lang? lang]) {
   return switch (lang) {
      Lang.en => tcEn,
      Lang.hi => tcHi ?? tcEn,
      _ => tcEn,
    };
  }

  String? tcLang([Lang? lang]) {
    return switch (lang) {
      Lang.en => tcEn,
      Lang.hi => tcHi,
      _ => tcEn,
    };
  }

  String privacy([Lang? lang]) {
    return switch (lang) {
      Lang.en => privacyEn,
      Lang.hi => privacyHi ?? privacyEn,
      _ => privacyEn,
    };
  }

  String? privacyLang([Lang? lang]) {
    return switch (lang) {
      Lang.en => privacyEn,
      Lang.hi => privacyHi,
      _ => privacyEn,
    };
  }

  String about([Lang? lang]) {
    return switch (lang) {
      Lang.en => aboutEn,
      Lang.hi => aboutHi ?? aboutEn,
      _ => aboutEn,
    };
  }

  String? aboutLang([Lang? lang]) {
    return switch (lang) {
      Lang.en => aboutEn,
      Lang.hi => aboutHi,
      _ => aboutEn,
    };
  }
}
