// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:avahan/core/enums/gender.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/loc_obj.dart';
import 'package:avahan/core/models/profile.dart';

class AdminProfilesState {
  final bool loading;
  final String searchKey;
  final List<Profile> profiles;
  final int page;
  final int count;
  final ({int min, int? max})? age;
  final Gender? gender;
  final Lang? lang;
  final LocObj? country;
  final LocObj? state;
  final String? city;
  final bool? premium;
  final bool? lifetime;
  final bool? expired;
  final bool? birthday;
  final bool? joined;
  final Set<String> sort;

  final bool desending;
  final String sortKey;
  
  static const id = 'id';
  static const createdAt = 'createdAt';
  static const name = 'name';

  AdminProfilesState({
    required this.loading,
    required this.profiles,
    required this.page,
    required this.count,
    required this.searchKey,
    this.age,
    this.birthday,
    this.city,
    this.country,
    this.state,
    this.expired,
    this.gender,
    this.lang,
    this.premium,
    this.sort = const {},
    this.desending = false,
    this.sortKey = id,
    this.joined,
    this.lifetime,
  });

  AdminProfilesState copyWith({
    bool? loading,
    String? searchKey,
    List<Profile>? profiles,
    int? page,
    int? count,
    ({int min, int? max})? age,
    Gender? gender,
    Lang? lang,
    LocObj? country,
    LocObj? state,
    String? city,
    bool? premium,
    bool? expired,
    bool? birthday,
    bool clearAge = false,
    bool clearGender = false,
    bool clearLang = false,
    bool clearCountry = false,
    bool clearState = false,
    bool clearCity = false,
    bool clearPremium = false,
    bool clearExpired = false,
    bool clearBirthday = false,
    Set<String>? sort,
    bool? desending,
    String? sortKey,
    bool? joined,
    bool clearJoined = false,
    bool? lifetime,
    bool clearLifetime = false,
  }) {
    return AdminProfilesState(
      loading: loading ?? this.loading,
      searchKey: searchKey ?? this.searchKey,
      profiles: profiles ?? this.profiles,
      page: page ?? this.page,
      count: count ?? this.count,
      age: clearAge ? null : age ?? this.age,
      gender: clearGender ? null : gender ?? this.gender,
      lang: clearLang ? null : lang ?? this.lang,
      country: clearCountry ? null : country ?? this.country,
      state: clearState ? null : state ?? this.state,
      city: clearCity ? null : city ?? this.city,
      premium: clearPremium ? null : premium ?? this.premium,
      expired: clearExpired ? null : expired ?? this.expired,
      birthday: clearBirthday ? null : birthday ?? this.birthday,
      sort: sort ?? this.sort,
      desending: desending ?? this.desending,
      sortKey: sortKey ?? this.sortKey,
      joined: clearJoined? null: joined ?? this.joined,
      lifetime: clearLifetime? null: lifetime ?? this.lifetime,
    );
  }
}
