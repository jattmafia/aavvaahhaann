// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:avahan/core/models/datetime_slot.dart';
import 'package:equatable/equatable.dart';

import 'package:avahan/core/models/app_banner.dart';



class MasterData extends Equatable {
  final int version;
  final int versionIos;
  final bool force;
  final bool forceIos;
  final List<AppBanner> banners;
  final List<int> freeTrialTracks;
  final List<String> groupIds;
  final List<DateTimeSlot> freeSlots;
  final int freeTrailDays;
  final String contactPhone;
  final String contactEmail;
  final String appShareMessage;
  final String termsUrl;
  final String privacyUrl;
  final String aboutEnUrl;
  final String aboutHiUrl;
  final bool maintenance;

  const MasterData({
    required this.version,
    required this.versionIos,
    required this.force,
    required this.forceIos,
    required this.banners,
    required this.freeTrialTracks,
    required this.freeSlots,
    required this.groupIds,
    required this.freeTrailDays,
    required this.contactPhone,
    required this.contactEmail,
    required this.appShareMessage,
    required this.termsUrl,
    required this.privacyUrl,
    required this.aboutEnUrl,
    required this.aboutHiUrl,
    required this.maintenance,
  });

  @override
  List<Object?> get props => [
        version,
        versionIos,
        force,
        forceIos,
        banners,
        freeTrialTracks,
        freeSlots,
        groupIds,
        freeTrailDays,
        contactPhone,
        contactEmail,
        appShareMessage,
        termsUrl,
        privacyUrl,
        aboutEnUrl,
        aboutHiUrl,
        maintenance,
      ];

  MasterData copyWith({
    int? version,
    int? versionIos,
    bool? force,
    bool? forceIos,
    List<AppBanner>? banners,
    List<int>? freeTrialTracks,
    List<DateTimeSlot>? freeSlots,
    List<String>? groupIds,
    int? freeTrailDays,
    String? contactPhone,
    String? contactEmail,
    String? appShareMessage,
    String? termsUrl,
    String? privacyUrl,
    String? aboutEnUrl,
    String? aboutHiUrl,
    bool? maintenance,
  }) {
    return MasterData(
      version: version ?? this.version,
      versionIos: versionIos ?? this.versionIos,
      force: force ?? this.force,
      forceIos: forceIos ?? this.forceIos,
      banners: banners ?? this.banners,
      freeTrialTracks: freeTrialTracks ?? this.freeTrialTracks,
      freeSlots: freeSlots ?? this.freeSlots,
      groupIds: groupIds ?? this.groupIds,
      freeTrailDays: freeTrailDays ?? this.freeTrailDays,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      appShareMessage: appShareMessage ?? this.appShareMessage,
      termsUrl: termsUrl ?? this.termsUrl,
      privacyUrl: privacyUrl ?? this.privacyUrl,
      aboutEnUrl: aboutEnUrl ?? this.aboutEnUrl,
      aboutHiUrl: aboutHiUrl ?? this.aboutHiUrl,
      maintenance: maintenance ?? this.maintenance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'version': version,
      'versionIos': versionIos,
      'force': force,
      'forceIos': forceIos,
      'banners': banners.map((e) => e.toMap()).toList(),
      'freeTrialTracks': freeTrialTracks,
      'freeSlots': freeSlots.map((e) => e.toMap()).toList(),
      'groupIds': groupIds,
      'freeTrailDays': freeTrailDays,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'appShareMessage': appShareMessage,
      'termsUrl': termsUrl,
      'privacyUrl': privacyUrl,
      'aboutEnUrl': aboutEnUrl,
      'aboutHiUrl': aboutHiUrl,
      'maintenance': maintenance,
    };
  }

  factory MasterData.fromMap(Map<String, dynamic> map) {
    return MasterData(
      version: map['version'] as int,
      versionIos: map['versionIos'] as int,
      force: map['force'] as bool,
      forceIos: map['forceIos'] as bool,
      banners: List<AppBanner>.from(
        map['banners']?.map((x) => AppBanner.fromMap(x)) ?? [],
      ),
      freeTrialTracks: List<int>.from(map['freeTrialTracks'] ?? []),
      freeSlots: List<DateTimeSlot>.from(
        map['freeSlots']?.map((x) => DateTimeSlot.fromMap(x)) ?? [],
      ),
      groupIds: List<String>.from(map['groupIds']?? []),
      freeTrailDays: map['freeTrailDays'] as int? ?? 0,
      contactPhone: map['contactPhone'] as String? ?? '',
      contactEmail: map['contactEmail'] as String? ?? '',
      appShareMessage: map['appShareMessage'] as String? ?? '',
      termsUrl: map['termsUrl'] as String? ?? '',
      privacyUrl: map['privacyUrl'] as String? ?? '',
      aboutEnUrl: map['aboutEnUrl'] as String? ?? '',
      aboutHiUrl: map['aboutHiUrl'] as String? ?? '',
      maintenance: map['maintenance'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MasterData.fromJson(String source) =>
      MasterData.fromMap(json.decode(source) as Map<String, dynamic>);
}
