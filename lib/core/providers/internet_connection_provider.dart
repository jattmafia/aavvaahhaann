import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final internetConnectionProvider = StreamProvider<bool>((ref) {
  final controller = StreamController<bool>();

  final value = InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 2),
    checkInterval: const Duration(seconds: 5),
  );

  value.hasConnection.then((value) {
    print("InternetConnectionChecker");
    print(value);
    controller.add(value);
  });
  final StreamSubscription<List<ConnectivityResult>> subscription = Connectivity()
      .onConnectivityChanged
      .listen(( result) async {
    final v = await value.hasConnection;
    print("InternetConnectionChecker");
    print(v);
    controller.add(v);
  });
  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });
  return controller.stream;
});
