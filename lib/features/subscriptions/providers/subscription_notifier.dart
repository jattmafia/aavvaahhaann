import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';


final subscriptionProvider = Provider((ref) => SubscriptionNotifier(ref));

class SubscriptionNotifier {
  final Ref _ref;

  SubscriptionNotifier(this._ref);

  Future<void> init() async {
   final v = await RevenueCatUI.presentPaywallIfNeeded("premium");
   print("Did purchase: $v");
  }
}
