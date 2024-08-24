import 'dart:async';

import 'package:avahan/core/providers/messaging_provider.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// final premiumProvider = StreamProvider((ref) {
//   final controller = StreamController<bool>();
//   // final uid = ref.watch(sessionProvider.select((value) => value?.user.id));
//   final uid = ref.watch(
//       yourProfileProvider.select((value) => value.asData?.value.id.toString()));
//   final messaging = ref.read(messagingProvider);
//   if (uid == null) {
//     controller.add(false);
//   } else {
//     void handle(CustomerInfo info) {
//       if (info.entitlements.all["premium"]?.isActive ?? false) {
//         messaging.subscribeToTopic("premium");
//         messaging.unsubscribeFromTopic("freetrial");
//         controller.add(true);
//       } else {
//         final profile = ref.read(yourProfileProvider).value!;
//         if ((profile.oldPurchase && profile.premium && !profile.expired) ||
//             profile.lifetime) {
//           messaging.subscribeToTopic("premium");
//           messaging.unsubscribeFromTopic("freetrial");
//           controller.add(true);
//         } else {
//           controller.add(false);
//         }
//       }
//     }

//     Future<void> init() async {
//       try {
//         final profile = ref.read(yourProfileProvider).value!;
//         if (await Purchases.isAnonymous) {
//           print(uid);
//           final result = await Purchases.logIn(uid);
//           print(await Purchases.appUserID);
//           print(result.customerInfo.originalAppUserId);
//           Purchases.setDisplayName(profile.name);
//           if (profile.email != null) {
//             Purchases.setEmail(profile.email!);
//           }
//           if (profile.phoneNumber != null) {
//             Purchases.setPhoneNumber(profile.phoneNumber!);
//           }

//           handle(result.customerInfo);
//         } else {
//           final info = await Purchases.getCustomerInfo();
//           print('---------------------------');
//           print(await Purchases.appUserID);
//           print(info.originalAppUserId);
//           handle(info);
//         }
//       } catch (e) {
//         debugPrint("Error: $e");
//       }
//     }

//     init();
//     Purchases.addCustomerInfoUpdateListener(
//       (info) => handle(info),
//     );
//     ref.onDispose(() {
//       controller.close();
//       Purchases.removeCustomerInfoUpdateListener(handle);
//     });
//   }

//   return controller.stream;
// });

final premiumProvider = StreamProvider((ref) {
  final controller = StreamController<bool>();

  // controller.add(false);
  final messaging = ref.read(messagingProvider);

  ref.watch(googlePremiumProvider.future).then((value) {
    if (value) {
      controller.add(value);
    } else {
      final profile = ref.read(yourProfileProvider).value!;
      if ((profile.oldPurchase && profile.premium && !profile.expired) ||
          profile.lifetime) {
        messaging.subscribeToTopic("premium");
        messaging.unsubscribeFromTopic("freetrial");
        controller.add(true);
      } else {
        controller.add(false);
      }
    }
  });

  return controller.stream;
});


final googlePremiumProvider = StreamProvider((ref) {
  final controller = StreamController<bool>();
  final uid = ref.watch(
      yourProfileProvider.select((value) => value.asData?.value.id.toString()));
  final messaging = ref.read(messagingProvider);
  if (uid == null) {
    controller.add(false);
  } else {
    void handle(CustomerInfo info) {
      if (info.entitlements.all["premium"]?.isActive ?? false) {
        messaging.subscribeToTopic("premium");
        messaging.unsubscribeFromTopic("freetrial");
        controller.add(true);
      } else {
        controller.add(false);
      }
    }

    Future<void> init() async {
      try {
        final profile = ref.read(yourProfileProvider).value!;
        if (await Purchases.isAnonymous) {
          print(uid);
          final result = await Purchases.logIn(uid);
          print(await Purchases.appUserID);
          print(result.customerInfo.originalAppUserId);
          Purchases.setDisplayName(profile.name);
          if (profile.email != null) {
            Purchases.setEmail(profile.email!);
          }
          if (profile.phoneNumber != null) {
            Purchases.setPhoneNumber(profile.phoneNumber!);
          }

          handle(result.customerInfo);
        } else {
          final info = await Purchases.getCustomerInfo();
          print('---------------------------');
          print(await Purchases.appUserID);
          print(info.originalAppUserId);
          handle(info);
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    }

    init();
    Purchases.addCustomerInfoUpdateListener(
      (info) => handle(info),
    );
    ref.onDispose(() {
      controller.close();
      Purchases.removeCustomerInfoUpdateListener(handle);
    });
  }

  return controller.stream;
});
