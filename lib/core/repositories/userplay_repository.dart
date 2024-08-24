import 'dart:developer';

import 'package:avahan/core/models/user_today_songs.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

 final userplayRepository = Provider(UserplayRepository.new);

class UserplayRepository{
   final Ref _ref;

   UserplayRepository(this._ref);
   supabase.SupabaseClient get _client => _ref.read(clientProvider);
    


    Future<List<UserTodaySongs>> getuserPlay({required String  id,required String date}) async {
    try{
      var res = await _client.from('play_sessions').select().filter('startedAt', 'gt', date).eq('userId', id).select().select('tracks(id,nameEn),totalDuration,duration,rootType,rootId,startedAt,endedAt,userId');
                                       log(res.toString());

//                                      //  final List<dynamic> jsonResponse = json.decode(res);
   final List<UserTodaySongs> models = res.map((data) => UserTodaySongs.fromJson(data)).toList();
   
   return models;
    }on Exception catch (e) {
      return Future.error(e);
    }
    }
}