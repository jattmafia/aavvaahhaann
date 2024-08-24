import 'dart:developer';

import 'package:avahan/admin/profiles/models/profiles_state.dart';
import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sessionuser_notifier.g.dart';

@riverpod
class SessionUserNotifier extends _$SessionUserNotifier {
  @override
  AdminProfilesState build(List data){

  Future.delayed(
      const Duration(milliseconds: 500),
      () {
        
        _fetch(data);
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

 ProfileRepository get _repository => ref.read(profileRepositoryProvider);

_fetch(List data) async {

  try{
      if (!state.loading) {
        state = state.copyWith(loading: true);
      }

 final result = await   _repository.getsessionuserprofiles(data);
  state = state.copyWith(
        loading: false,
        profiles: result ?? [],
       
      );

  
  }catch(e){
    log(e.toString());
  }

}

} 
