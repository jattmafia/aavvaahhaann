import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomeDialog extends ConsumerWidget {
  const WelcomeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(yourProfileProvider).value!;
    return Dialog(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(Assets.welcome),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(right: 56),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  "Namaskar, welcome to Avahan\n-music that radiates blessings & fills your\nhome with powerful energy",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Text(
                  "नमस्कार, आवाहन में आपका स्वागत है\n- सुनिए भक्ति और सकारात्मक ऊर्जा से परिपूर्ण\nसंगीत हर दिन",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (!profile.premium && !profile.expired && !profile.lifetime)
                  Text(
                    "",
                    style: TextStyle(color: context.scheme.primary),
                  ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Transform.translate(
              offset: Offset(32, -32),
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: context.scheme.surface,
                  foregroundColor: context.scheme.onSurface,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
