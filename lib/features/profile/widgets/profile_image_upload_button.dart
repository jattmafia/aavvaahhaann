// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:avahan/features/profile/providers/write_profile_notifier.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/utils/extensions.dart';

class ProfileImageUploadButton extends ConsumerWidget {
  const ProfileImageUploadButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.read(yourProfileProvider).value!;
    final provider = writeProfileProvider(profile);
    final state = ref.watch(provider);
    final notifier = ref.watch(provider.notifier);

    return Positioned(
      bottom: 0,
      right: 0,
      child: SizedBox(
        height: 24,
        width: 24,
        child: state.loading
            ? const CircularProgressIndicator()
            : RawMaterialButton(
                shape: const CircleBorder(),
                fillColor: context.scheme.primary,
                onPressed: () async {
                  final picked = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  // if (picked != null) {
                  //   notifier.fileChanged(picked);
                  // }

                  try {
                    await notifier.write();
                  } catch (e) {
                    context.error(e);
                  }
                },
                child: Icon(
                  Icons.upload,
                  color: context.scheme.onPrimary,
                  size: 16,
                ),
              ),
      ),
    );
  }
}
