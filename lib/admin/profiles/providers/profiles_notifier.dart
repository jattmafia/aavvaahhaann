import 'package:avahan/admin/dashboard/providers/admin_dashboard_notifier.dart';
import 'package:avahan/core/enums/gender.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/debouncer.dart';
import 'package:avahan/core/models/loc_obj.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:avahan/admin/dashboard/models/admin_dashboard_state.dart';
import 'package:avahan/admin/profiles/models/profiles_state.dart';
import 'package:avahan/core/repositories/profile_repository.dart';

part 'profiles_notifier.g.dart';

@riverpod
class AdminProfilesNotifier extends _$AdminProfilesNotifier {
  @override
  AdminProfilesState build() {
    debouncer = Debouncer(
      const Duration(milliseconds: 500),
      (value) {
        searchKeyChanged(value);
      },
    );
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        
        _fetch();
      },
    );
    return AdminProfilesState(
      loading: true,
      profiles: [],
      page: 0,
      count: 0,
      searchKey: '',
    );
  }

 

  List<Map<String, dynamic>> sortOptions = [
    {'name': 'name a - z', 'key': 'name', 'decending': false},
    {'name': 'name z - a', 'key': 'name', 'decending': true},
    {'name': 'new joined', 'key': 'createdAt', 'decending': true},


  ];
   void sortOptionChange( newValue) {
    sortChanged(newValue['key'], newValue['decending']);
  }
  

  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  late Debouncer debouncer;

  void searchKeyChanged(String v) {
    state = state.copyWith(searchKey: v);
    _fetch();
  }

  void pageChanged(int v) {
    state = state.copyWith(page: v);
    _fetch();
  }

  AdminDashboardState get dashboardState =>
      ref.read(adminDashboardNotifierProvider);
  AdminDashboardNotifier get dashboardNotifier =>
      ref.read(adminDashboardNotifierProvider.notifier);

  void refresh() {
    _fetch();
  }

  void _fetch() async {
    try {
      if (!state.loading) {
        state = state.copyWith(loading: true);
      }

           
      final result = await _repository.paginateProfiles(
        page: state.page,
        name: int.tryParse(state.searchKey) == null &&
                !state.searchKey.contains('@')
            ? state.searchKey
            : null,
            city: int.tryParse(state.searchKey) == null &&
                !state.searchKey.contains('@')
            ? state.searchKey
            : null ,   
            state: int.tryParse(state.searchKey) == null &&
                !state.searchKey.contains('@')
            ? state.searchKey
            : null ,
        id: int.tryParse(state.searchKey) != null && state.searchKey.length < 6
            ? int.parse(state.searchKey)
            : null,
        phoneNumber: int.tryParse(state.searchKey) != null &&
                state.searchKey.length >= 10
            ? state.searchKey
            : null,
         
        email: state.searchKey.contains('@') ? state.searchKey : null,
        ageMax: state.age?.max,
        ageMin: state.age?.min,
        birthday: state.birthday,
        
        country: state.country,
        expired: state.expired,
        
        gender: state.gender,
        lang: state.lang,
        premium: state.premium,
        sortKey: state.sortKey,
        desending: state.desending,
        joined: state.joined,
        lifetime: state.lifetime,
      );

      state = state.copyWith(
        loading: false,
        profiles: result.$2,
        count: result.$1,
      );
    } catch (e) {
      debugPrint("$e");
    }
  }

  void ageChanged(({int min, int? max})? range) {
    state = state.copyWith(age: range, clearAge: range == null, sort: {
      ...state.sort,
      "age",
    });
    _fetch();
  }

  void joinedChanged(bool? joined) {
    state = state.copyWith(
      joined: joined,
      clearJoined: joined == null,
      sort: {
        ...state.sort,
        "joined",
      },
    );
    _fetch();
  }

  void genderChanged(Gender? gender) {
    state = state.copyWith(gender: gender, clearGender: gender == null, sort: {
      ...state.sort,
      "gender",
    });
    _fetch();
  }

  void langChanged(Lang? lang) {
    state = state.copyWith(
      lang: lang,
      clearLang: lang == null,
      sort: {
        ...state.sort,
        "lang",
      },
    );
    _fetch();
  }

  void sortChanged(String key, bool desending) {
    state = state.copyWith(
      sortKey: key,
      desending: desending,
    );
    _fetch();
  }

  void countryChanged(LocObj? country) {
    state = state.copyWith(
      country: country,
      clearCountry: country == null,
      sort: {
        ...state.sort,
        "country",
      },
    );
    _fetch();
  }

  void stateChanged(LocObj? state_) {
    state = state.copyWith(
      state: state_,
      clearState: state_ == null,
      sort: {
        ...state.sort,
        "state",
      },
    );
    _fetch();
  }

  void cityChanged(String? city) {
    state = state.copyWith(
      city: city,
      clearCity: city == null,
      sort: {
        ...state.sort,
        "city",
      },
    );
    _fetch();
  }

  void premiumChanged(bool? premium) {
    state = state.copyWith(
      premium: premium,
      clearPremium: premium == null,
      sort: {
        ...state.sort,
        "premium",
      },
    );
    _fetch();
  }

  void lifetimeChanged(bool? lifetime) {
    state = state.copyWith(
      lifetime: lifetime,
      clearLifetime: lifetime == null,
      sort: {
        ...state.sort,
        "lifetime",
      },
    );
    _fetch();
  }

  void expiredChanged(bool? expired) {
    state = state.copyWith(
      expired: expired,
      clearExpired: expired == null,
      sort: {
        ...state.sort,
        "expired",
      },
    );
    _fetch();
  }

  void birthdayChanged(bool? birthday) {
    state = state.copyWith(
      birthday: birthday,
      clearBirthday: birthday == null,
      sort: {
        ...state.sort,
        "birthday",
      },
    );
    _fetch();
  }

  void pushProfile(Profile profile) {
    state = state.copyWith(
      profiles:
          state.profiles.map((e) => e.id == profile.id ? profile : e).toList(),
    );
  }

  void removeUser(Profile profile) {
    state = state.copyWith(
      profiles: state.profiles.where((e) => e.id != profile.id).toList(),
       
    );
    
  }
}
