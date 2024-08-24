// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:avahan/core/providers/client_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:avahan/app.dart';
import 'package:avahan/config.dart';
import 'package:avahan/core/enums/app.dart';
import 'package:web/web.dart';

void main() {
  Config.setProd();
  runAdmin();
}

void runAdmin() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Config.supabaseProjectUrl,
    anonKey: Config.supabaseAnonKey,
  );
  Config.setApp(App.admin);
  final ref = ProviderContainer();
  final params =  Uri.parse(document.URL).queryParameters;
  print(params);
  if(params.containsKey('refresh_token')){
   try {
    print(params['refresh_token']);
     await ref.read(clientProvider).auth.setSession(params['refresh_token']!);
   } catch (e) {
     debugPrint("$e");
   }
  }
  runApp( UncontrolledProviderScope(container: ref,child: MyApp(),));
}
