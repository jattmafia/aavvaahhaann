// // ignore_for_file: use_build_context_synchronously

// import 'package:avahan/core/providers/cache_tracks_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:avahan/core/providers/cache_provider.dart';
// import 'package:avahan/core/providers/master_data_provider.dart';
// import 'package:avahan/features/profile/providers/your_profile_provider.dart';
// import 'package:avahan/features/providers/flow_provider.dart';
// import 'package:avahan/utils/extensions.dart';

// class SplashPage extends HookConsumerWidget {
//   const SplashPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     void init() async {
//       // await Future.delayed(
//       //   const Duration(seconds: 2),
//       // );
//       try {
//         await ref.read(cacheProvider.future);
//       } catch (e) {
//         debugPrint("$e");
//       }
//       try {
//         await ref.read(masterDataProvider.future);
//       } catch (e) {
//         debugPrint("$e");
//       }
//       try {
//         await ref.read(cacheTracksProvider.future);
//       } catch (e) {
//         debugPrint("$e");
//       }

//       try {
//         await ref.read(yourProfileProvider.future);
//       } catch (e) {
//         debugPrint("$e");
//       }

//       ref.read(flowProvider).splashSeen = true;
//       context.go();
//     }

//     useEffect(() {
//       init();
//       return () {};
//     });

//     return Scaffold(
//       backgroundColor: context.scheme.surface,
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Positioned(
//           //   left: -context.size_.width / 2,
//           //   right: -context.size_.width / 2,
//           //   child: SvgPicture.asset(
//           //     Assets.splashVectorLayer,
//           //   ),
//           // ),
//           SafeArea(
//             child: Center(
//               child: Image.asset(
//                 "assets/logo.png",
//                 height: 100,
//                 width: 100,
//               ),
//             ),
//           ),
//           // Positioned(
//           //   bottom: 40,
//           //   child: Material(
//           //     color: context.scheme.primary,
//           //     shape: const StadiumBorder(),
//           //     child: Padding(
//           //       padding: const EdgeInsets.all(16.0),
//           //       child: Column(
//           //         mainAxisSize: MainAxisSize.min,
//           //         children: [
//           //           Text(
//           //             'Powered by',
//           //             style: context.style.bodySmall!.copyWith(
//           //               color: context.scheme.onPrimary,
//           //             ),
//           //           ),
//           //           const SizedBox(height: 4),
//           //           SvgPicture.asset(
//           //             Assets.trueoneLogo,
//           //             height: 40,
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
