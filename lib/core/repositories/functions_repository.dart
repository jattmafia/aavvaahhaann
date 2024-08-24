import 'dart:convert';

import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:avahan/core/models/push_notification.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart';

final functionsRepositoryProvider = Provider(FunctionsRepository.new);

class FunctionsRepository {
  final Ref _ref;

  FunctionsRepository(this._ref);

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  Future<NotifyResult> sendNotification(
    PushNotification notification,
  ) async {
    try {
      print(_client.functions.headers);
      final res = await _client.functions.invoke(
        "notify",
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: notification.toMap(),
      );

      final data = jsonDecode(res.data);
      print(data);
      return NotifyResult(
        createdAt: DateTime.now(),
        failure: data['failure'] ?? 0,
        success: data['success'] ?? 0,
      );
    } on Exception catch (e) {
      if (e is FunctionException) {
        print((e as FunctionException).details);
        print((e as FunctionException).reasonPhrase);
      }
      return Future.error(e.parse);
    } on FunctionException catch (e) {
      print(e.details);
      print(e.reasonPhrase);
      return Future.error(e);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<void> cron() async {
    try {
      final res = await _client.functions.invoke(
        "notify_cron",
      );
      print(res.data);
      // final data = jsonDecode(res.data);
      // return NotifyResult(
      //   createdAt: DateTime.now(),
      //   failure: data['failure'],
      //   success: data['success'],
      // );
    } on Exception catch (e) {
      if (e is FunctionException) {
        print((e as FunctionException).details);
        print((e as FunctionException).reasonPhrase);
      }
      return Future.error(e.parse);
    } on FunctionException catch (e) {
      print(e.details);
      print(e.reasonPhrase);
      return Future.error(e);
    }
  }

  // Future<List<Profile>> filterUsers(PushNotification notification) async {
  //   print(notification.toFiltersMap());
  //   try {
  //     final res = await _client.functions.invoke(
  //       "filter_users",
  //       body: notification.toFiltersMap(),
  //     );
  //     return (res.data as Iterable)
  //         .map(
  //           (e) => Profile.fromMap(e),
  //         )
  //         .toList();
  //   } on Exception catch (e) {
  //     if (e is FunctionException) {
  //       print((e as FunctionException).details);
  //       print((e as FunctionException).reasonPhrase);
  //     }
  //     return Future.error(e.parse);
  //   } on FunctionException catch (e) {
  //     print(e.details);
  //     print(e.reasonPhrase);
  //     return Future.error(e);
  //   }
  // }

  void logoutFromAnotherDevice(String token) async {
    try {
      final Map<String,dynamic> body = {
        'token': token
      };
      final res = await _client.functions.invoke("logout", body: body);
      print(res.data);
    } on Exception catch (e) {
      if (e is FunctionException) {
        print((e as FunctionException).details);
        print((e as FunctionException).reasonPhrase);
      }
      return Future.error(e.parse);
    } on FunctionException catch (e) {
      print(e.details);
      print(e.reasonPhrase);
      return Future.error(e);
    }
  }


    void delete(String uid) async {
    try {
      final res = await _client.functions.invoke("delete_user", body: {
        'uid': uid
      });
      print(res.data);
    } on Exception catch (e) {
      if (e is FunctionException) {
        print((e as FunctionException).details);
        print((e as FunctionException).reasonPhrase);
      }
      return Future.error(e.parse);
    } on FunctionException catch (e) {
      print(e.details);
      print(e.reasonPhrase);
      return Future.error(e);
    }
  }
}
