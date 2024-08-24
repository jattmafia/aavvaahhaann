import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/utils/extensions.dart';

class ProfileDetailsPage extends ConsumerWidget {
  const ProfileDetailsPage({super.key});

  static const route = "/profile-details";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final profile = ref.read(yourProfileProvider).value!;
    return SizedBox();
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(labels.personalDetails),
    //   ),
    //   body: ListView(
    //     padding: const EdgeInsets.all(8),
    //     children: [
    //       KeyValueTile(labels.name, profile.name),
    //       KeyValueTile(labels.phoneNumber,
    //           profile.phoneNumber != null ? "+${profile.phoneNumber}" : ""),
    //       KeyValueTile(labels.email, profile.email ?? "-"),
    //     ]
    //         .map(
    //           (e) => Padding(
    //             padding: const EdgeInsets.all(8),
    //             child: e,
    //           ),
    //         )
    //         .toList(),
    //   ),
    // );
  }
}
