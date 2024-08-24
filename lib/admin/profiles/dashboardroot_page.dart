import 'dart:developer';

import 'package:avahan/admin/dashboard/widgets/statistics_view.dart';
import 'package:avahan/admin/dashboard/widgets/user_session_list_view.dart';
import 'package:avahan/admin/profiles/profile_page.dart';
import 'package:avahan/admin/profiles/providers/selecteduser_list_detail_provider.dart';
import 'package:avahan/admin/profiles/providers/selecteduser_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardrootPage extends ConsumerWidget{
  const DashboardrootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final state = ref.watch(selecteduserslistProvider);    
    final notifier = ref.read(selecteduserslistProvider.notifier);
    var userstate = ref.watch(selecteduserslistdetailProvider);    
    final usernotifier = ref.read(selecteduserslistdetailProvider.notifier);

    return Navigator(
      pages:  [
          const MaterialPage(child: StatisticsView()),
              if(state != null && userstate == null)
              MaterialPage(child: UserListPage(
                data: state
              )),

              if(userstate != null)
  MaterialPage(child: AdminProfilePage(
                profile: userstate,
              )),
             
      ],
         onPopPage: (route, result) {
          
        if (!route.didPop(result)) {
          return false;
        }
        if(userstate!= null){
          usernotifier.state = null;
          
        }else if (state != null && userstate == null) {
         
          notifier.state = null;
        }

        return true;
      },
    
      
    );
  }

}