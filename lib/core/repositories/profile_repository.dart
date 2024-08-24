import 'dart:developer';

import 'package:avahan/core/enums/gender.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/guest.dart';
import 'package:avahan/core/models/loc_obj.dart';
import 'package:avahan/core/models/location.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:avahan/core/providers/dio_provider.dart';
import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:avahan/core/providers/messaging_provider.dart';
import 'package:avahan/features/auth/providers/session_provider.dart';

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(ref),
);

class ProfileRepository {
  final Ref _ref;

  ProfileRepository(this._ref);

  static const _profiles = 'users';

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  // StorageRepository get _storage => _ref.read(storageRepositoryProvider);

  Future<Profile> getProfileFromUUID(String uuid) async {
    try {
      final data =
          await _client.from(_profiles).select('*').eq('uuid', uuid).single();
      return Profile.fromMap(data);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<Profile> getProfileFromPhoneNumber(
      String phoneNumber, String uuid) async {
    try {
      final data = await _client
          .from(_profiles)
          .select('*')
          .eq('phoneNumber', phoneNumber)
          .single();
      return _prepare(data, uuid);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<Profile> _prepare(Map<String, dynamic> data, String uuid) async {
    final masterdata = await _ref.read(masterDataProvider.future);

    final expiryAt =
        DateTime.now().add(Duration(days: masterdata.freeTrailDays));

    var profile = Profile.fromMap(data).copyWith(uuid: uuid);
    if (profile.expiryAt?.isBefore(expiryAt) ?? true) {
      profile = profile.copyWith(
        expiryAt: expiryAt,
        premium: false,
        oldPurchase: false,
      );
    }

    final updated = await _client
        .from(_profiles)
        .update(profile.toMap())
        .eq('id', profile.id)
        .select('*')
        .single();
    return Profile.fromMap(updated);
  }

  Future<Profile> getProfileFromEmail(String email, String uuid) async {
    try {
      final data =
          await _client.from(_profiles).select('*').eq('email', email).single();
      return _prepare(data, uuid);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<Profile> getProfile(int id) async {
    try {
      final data =
          await _client.from(_profiles).select('*').eq('id', id).single();
      return Profile.fromMap(data);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> writeProfile(
    Profile profile,
  ) async {
    try {
      await _client.from(_profiles).upsert(
            profile.toMap(),
          );
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateInfo(
    int id,
    Location? location,
    DateTime? dateOfBirth,
  ) async {
    try {
      await _client.from(_profiles).update({
        if (location != null) ...{
          'country': location.country,
          'state': location.state,
          'city': location.city,
          'isoCode': location.isoCode,
          'stateCode': location.state,
        },
        if (dateOfBirth != null)
          'dateOfBirth': dateOfBirth.toUtc().toIso8601String(),
      }).eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateFcmToken([String? fcmToken]) async {
    try {
      final user = _ref.read(sessionProvider)?.user;
      if (user == null) {
        return;
      }

      fcmToken ??= await _ref.read(messagingProvider).getToken();

      if (fcmToken == null) {
        return;
      }
      await _client
          .from(_profiles)
          .update({"fcmToken": fcmToken}).eq('uuid', user.id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateDeviceDetails({
    String? fcmToken,
    String? deviceId,
    String? deviceName,
    String? channel,
  }) async {
    try {
      final user = _ref.read(sessionProvider)?.user;
      if (user == null) {
        return;
      }
      await _client.from(_profiles).update({
        "fcmToken": fcmToken,
        "deviceId": deviceId,
        "deviceName": deviceName,
        "channel": channel,
      }).eq('uuid', user.id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> delete() async {
    try {
      final user = _ref.read(sessionProvider)?.user;
      if (user == null) {
        return;
      }
      await _client.from(_profiles).delete().eq('uuid', user.id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }
    
    Future getsessionuserprofiles(List data) async {
      //List a = ['54', '30'];
       try{
         var listRef = _client.from(_profiles).select(
            "*",
          ).filter('id', 'in',data);
        
          final Iterable countResult = await listRef.select();
      return 
        countResult.map((e) => Profile.fromMap(e)).toList();
       }catch(e){
        log('user sesson user list error $e');
       }
    }

 Future<(int count, List<Profile> profiles)> paginateProfilesForSearch({
    int? id,
    String? name,
    String? phoneNumber,
    String? email,
    required int page,
    final int? ageMin,
    int? ageMax,
    Gender? gender,
    Lang? lang,
    LocObj? country,
    LocObj? state,
    String? city,
    bool? premium,
    bool? lifetime,
    bool? expired,
    bool? birthday,
    String? sortKey,
    bool desending = false,
    bool? joined,
    String? channel,
  }) async {
    print("111111");
    try {
      var listRef = _client.from(_profiles).select(
            "*",
          );

      if (channel != null) {
        listRef = listRef.eq("channel", channel);
      }

      if (name != null) {
        print(name);
        listRef = listRef.ilike('name', "%$name%");
      } else if (id != null) {
        listRef = listRef.eq('id', id);
      } else if (phoneNumber != null) {
        listRef = listRef.ilike('phoneNumber', "%$phoneNumber%");
      } else if (email != null) {
        listRef = listRef.ilike('email', "%$email%");
      }

      if (ageMin != null) {
        listRef = listRef.lte(
          'dateOfBirth',
          DateTime.now().copyWith(
            year: DateTime.now().year - ageMin,
          ),
        );
      }

      if (ageMax != null) {
        listRef = listRef.gte(
          'dateOfBirth',
          DateTime.now().copyWith(
            year: DateTime.now().year - ageMax,
          ),
        );
      }

      if (gender != null) {
        listRef = listRef.eq("gender", gender.name);
      }

      if (lang != null) {
        listRef = listRef.eq("lang", lang.name);
      }

      if (country != null) {
        listRef = listRef.eq("isoCode", country.iso);
      } else if (joined != null) {
        listRef = listRef.not("isoCode", 'is', null);
      }

      if (state != null) {
        listRef = listRef.eq("stateCode", state.iso);
      }

      if (city != null) {
        listRef = listRef.eq("city", city);
      }

      if (premium != null) {
        listRef = listRef.eq("premium", premium);
      } else if (lifetime != null) {
        listRef = listRef.eq("lifetime", lifetime);
      }

      if (expired != null) {
        if (expired) {
          listRef =
              listRef.lte("expiryAt", DateTime.now().toUtc().toIso8601String());
        } else {
          listRef =
              listRef.gte("expiryAt", DateTime.now().toUtc().toIso8601String());
        }
      }

      if (birthday != null) {
        listRef = listRef.eq("birthday", birthday);
      }

      final Iterable results = await listRef
          .order(
            sortKey ?? 'id',
            ascending: !desending,
          )
          .range(
            page * 10,
            page * 10 + 9, // TODO
          );

      final countResult = await listRef.count();
      return (
        countResult.count,
        results.map((e) => Profile.fromMap(e)).toList(),
      );
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }


  Future<(int count, List<Profile> profiles)> paginateProfiles({
    int? id,
    String? name,
    String? phoneNumber,
    String? email,
    required int page,
    final int? ageMin,
    int? ageMax,
    Gender? gender,
    Lang? lang,
    LocObj? country,
    String? state,
    String? city,
    bool? premium,
    bool? lifetime,
    bool? expired,
    bool? birthday,
    String? sortKey,
    bool desending = false,
    bool? joined,
    String? channel,
  }) async {
    print("111111");
    try {
      var listRef = _client.from(_profiles).select(
            "*",
          );

      if (channel != null) {
        listRef = listRef.eq("channel", channel);
      }

      // if (name != null) {
      //   print(name);
      //    listRef = listRef.ilike('city', "%$name%");

        
      // }
        
     if (name != null) {
        print(name);
      listRef =   _client.from(_profiles).select(
            "*",
          ).or('name.ilike."%$name%",city.ilike."%$city%",state.ilike."%$state%"');
       //  listRef = listRef.ilike('name', "%$name%");

        
      } 
    //else if (city != null) {
    //     log("message");
    //     //  listRef =   _client.from(_profiles).select(
    //     //     "*",
    //     //   );
    //   //  listRef = listRef.ilike('city', "%$city%");
    //  }
      else if (id != null) {
        listRef = listRef.eq('id', id);
      } 
       else if (phoneNumber != null) {
        listRef = listRef.ilike('phoneNumber', "%$phoneNumber%");
      } else if (email != null) {
        listRef = listRef.ilike('email', "%$email%");
      }

      if (ageMin != null) {
        listRef = listRef.lte(
          'dateOfBirth',
          DateTime.now().copyWith(
            year: DateTime.now().year - ageMin,
          ),
        );
      }

      if (ageMax != null) {
        listRef = listRef.gte(
          'dateOfBirth',
          DateTime.now().copyWith(
            year: DateTime.now().year - ageMax,
          ),
        );
      }

      if (gender != null) {
        listRef = listRef.eq("gender", gender.name);
      }

      if (lang != null) {
        listRef = listRef.eq("lang", lang.name);
      }

      if (country != null) {
        listRef = listRef.eq("isoCode", country.iso);
      } else if (joined != null) {
        listRef = listRef.not("isoCode", 'is', null);
      }

      // if (state != null) {
      //   listRef = listRef.eq("stateCode", state.iso);
      // }

      // if (city != null) {
      //   listRef = listRef.ilike("city", city);
      // }

      if (premium != null) {
        listRef = listRef.eq("premium", premium);
      } else if (lifetime != null) {
        listRef = listRef.eq("lifetime", lifetime);
      }

      if (expired != null) {
        if (expired) {
          listRef =
              listRef.lte("expiryAt", DateTime.now().toUtc().toIso8601String());
        } else {
          listRef =
              listRef.gte("expiryAt", DateTime.now().toUtc().toIso8601String());
        }
      }

      if (birthday != null) {
        listRef = listRef.eq("birthday", birthday);
      }
 // log(sortKey!);
      final Iterable results = await listRef
          .order(
            sortKey ?? 
            'name',
            ascending: !desending,
          )
          .range(
            page * 10,
            page * 10 + 9, // TODO
          );

          log(results.toString());

      final countResult = await listRef.count();
      return (
        countResult.count,
        results.map((e) => Profile.fromMap(e)).toList(),
      );
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<int> totalProfiles() async {
    try {
      return _client.from(_profiles).count();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<int> totalPremiumProfiles() async {
    try {
      return _client
          .from(_profiles)
          .count()
          .eq(
            'premium',
            true,
          )
          .gt(
            'expiryAt',
            DateTime.now().toUtc().toIso8601String(),
          );
    } on Exception catch (e) {
      log("this is error $e");
      return Future.error(e.parse);
    }
  }

  Future<int> totalLifetimeProfiles() async {
    try {
      return _client.from(_profiles).count().eq('lifetime', true);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  // Future<void> updateStatus(int id, Status status) async {
  //   try {
  //     await _client.from(_profiles).update({
  //       'status': status.name,
  //     }).eq(
  //       'id',
  //       id,
  //     );
  //   } on Exception catch (e) {
  //     return Future.error(e.parse);
  //   }
  // }

  Future<void> deleteProfile(int id) async {
    try {
      await _client.from(_profiles).delete().eq(
            'id',
            id,
          );
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> langUpdate(int id, Lang lang) async {
    try {
      await _client.from(_profiles).update({
        'lang': lang.name,
      }).eq(
        'id',
        id,
      );
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<Location> getCurrentLocation() async {
    try {
      final res = await _ref.read(dioProvider).get('https://ip.grocbay.com/');
      return Location.fromMap(res.data['data']);
    } on DioException catch (e) {
      return Future.error(e.parse);
    }
  }

  void updateEmail(int id, String email) async {
    try {
      await _client.from(_profiles).update({
        'email': email,
      }).eq(
        'id',
        id,
      );
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  void updatePhoneNumber(int id, String phoneNumber) async {
    try {
      await _client.from(_profiles).update({
        'phoneNumber': phoneNumber,
      }).eq(
        'id',
        id,
      );
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> lifeTime(int id, bool v) async {
    try {
      await _client.from(_profiles).update({
        'lifetime': v,
      }).eq(
        'id',
        id,
      );
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> premium(int id, DateTime purchasedAt, DateTime expiryAt) async {
    try {
      await _client.from(_profiles).update({
        'premium': true,
        'purchasedAt': purchasedAt.toUtc().toIso8601String(),
        'expiryAt': expiryAt.toUtc().toIso8601String(),
        'oldPurchase': true,
      }).eq(
        'id',
        id,
      );
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> removePremium(int id, DateTime createdAt) async {
    try {
      await _client.from(_profiles).update({
        'premium': false,
        'purchasedAt': null,
        'expiryAt': createdAt.add(const Duration(days: 14)).toUtc().toIso8601String(),
        'oldPurchase': null,
      }).eq(
        'id',
        id,
      );
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  // Future<void> purchase(int id) async {
  //   try {
  //     await _client.from(_profiles).update({
  //       'planExpireAt': DateTime.now()
  //           .add(const Duration(days: 30))
  //           .toUtc()
  //           .toIso8601String(),
  //     }).eq(
  //       'id',
  //       id,
  //     );
  //   } on Exception catch (e) {
  //     return Future.error(e.parse);
  //   }
  // }
}
