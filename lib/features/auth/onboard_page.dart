// ignore_for_file: use_build_context_synchronously

import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/features/auth/create_account_page.dart';
import 'package:avahan/features/auth/login_page.dart';
import 'package:avahan/features/auth/phone_login_page.dart';
import 'package:avahan/features/auth/widgets/device_dialog.dart';
import 'package:avahan/features/components/lang_button.dart';
import 'package:avahan/features/components/loading_layer.dart';
import 'package:avahan/features/components/svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/features/auth/large_auth_view_wrapper.dart';
import 'package:avahan/features/auth/providers/auth_notifier_provider.dart';
import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OnboardPage extends ConsumerWidget {
  const OnboardPage({super.key});

  static const route = "/onboard";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final state = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);
    final child = LoadingLayer(
      loading: state.loading,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.baseline,
            // textBaseline: TextBaseline.ideographic,
            children: [
              SvgPicture.asset("assets/logo.svg", height: 24),
              const SizedBox(width: 8),
              Text(
                labels.avahan.toUpperCase(),
                style: context.style.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: context.scheme.primary,
                  fontSize: ref.lang == Lang.hi ? 28 : null,
                ),
              ),
            ],
          ),
          actions: const [LangButton()],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Image.asset(Assets.sadhu3),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0).copyWith(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: () {
                        context.push(CreateAccountPage.route);
                      },
                      child: Text(labels.signUpForFree),
                    ),

                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () {
                        context.push(LoginPage.route);
                      },
                      child: Text(labels.login),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10)),
                      onPressed: () {
                        context.push(PhoneLoginPage.route);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.phone),
                          Text(labels.continueWithPhoneNumber),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          labels.phoneNumberLoginIsSupported,
                          style: context.style.bodySmall!
                              .copyWith(color: context.scheme.outline),
                        ),
                      ],
                    ),
                  if(defaultTargetPlatform == TargetPlatform.iOS)  ...[
                      const SizedBox(height: 8),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF000000),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await notifier.signInWithApple();
                            context.go();
                          } catch (e) {
                            if (e == "device-unmatched") {
                              final result = await showDialog<bool>(
                                context: context,
                                builder: (context) => const DeviceDialog(),
                              );
                              if (result == true) {
                                await notifier.update(true);
                                context.go();
                              } else {
                                await notifier.logout();
                              }
                            } else {
                              context.error(e);
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgIcon(
                              Assets.apple,
                              color: context.scheme.surface,
                              size: 20,
                            ),
                                                        const SizedBox(width: 8),
                            Text(labels.continueWithApple),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await notifier.signInWithGoogle();
                          context.go();
                        } catch (e) {
                          if (e == "device-unmatched") {
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (context) => const DeviceDialog(),
                            );
                            if (result == true) {
                              await notifier.update(true);
                              context.go();
                            } else {
                              await notifier.logout();
                            }
                          } else {
                            context.error(e);
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            Assets.google,
                            height: 24,
                            width: 24,
                          ),
                          Text(labels.continueWithGoogle),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 8),
                    // OutlinedButton(
                    //   style: OutlinedButton.styleFrom(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 16,
                    //       vertical: 10,
                    //     ),
                    //   ),
                    //   onPressed: () {},
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       SvgPicture.asset(
                    //         Assets.facebook,
                    //         height: 24,
                    //         width: 24,
                    //       ),
                    //       Text(labels.continueWithFacebook),
                    //       const SizedBox(width: 20),
                    //     ],
                    //   ),
                    // ),
                    
                    const SizedBox(height: 8),
                    if (!context.canPop &&
                        defaultTargetPlatform == TargetPlatform.iOS)
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: context.scheme.secondary,
                        ),
                        onPressed: () async {
                          await notifier.skip();
                          context.go();
                        },
                        child: Text(labels.continueAsGuest),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (context.large) {
      return LargeAuthViewWrapper(page: child);
    } else {
      return child;
    }
  }
}
