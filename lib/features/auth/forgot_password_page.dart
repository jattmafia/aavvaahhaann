// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:avahan/features/auth/reset_password_page.dart';
import 'package:avahan/features/auth/providers/auth_notifier_provider.dart';
import 'package:avahan/features/auth/providers/session_provider.dart';
import 'package:avahan/features/auth/widgets/device_dialog.dart';
import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgotPasswordPage extends HookConsumerWidget {
  const ForgotPasswordPage({super.key});

  static const route = "/forgot-password";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailFormKey = useState(GlobalKey<FormState>());
    final labels = context.labels;
    final state = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);

    final controller = useTabController(
      initialLength: 3,
    );

    void reset() {
      controller.animateTo(2);
    }

    useEffect(() {
      final sub =
          ref.read(clientProvider).auth.onAuthStateChange.listen((value) async {
        if (value.session != null) {
          try {
            ref.refresh(sessionProvider);
            await notifier.check();
            reset();
          } catch (e) {
            if (e == "device-unmatched") {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => const DeviceDialog(),
              );
              if (result == true) {
                await notifier.update(true);
                reset();
              } else {
                await notifier.logout();
              }
            } else {
              context.error(e);
            }
          }
        }
      }, onError: (err) {
        context.error(err);
      });
      return () {
        sub.cancel();
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(labels.resetYourPassword),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0).copyWith(top: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    labels.enterYourEmailAddress,
                    style: context.style.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Form(
                    key: emailFormKey.value,
                    child: TextFormField(
                      autofocus: true,
                      initialValue: state.email,
                      onChanged: notifier.emailChanged,
                      validator: Validators.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      onPressed: state.loading || state.email.isEmpty
                          ? null
                          : () async {
                              if (emailFormKey.value.currentState!.validate()) {
                                try {
                                  await notifier.forgotPasssword();
                                  controller.animateTo(1);
                                  FocusScope.of(context).unfocus();
                                } catch (e) {
                                  context.error(e);
                                }
                              }
                            },
                      child: Text(labels.next),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0).copyWith(top: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    labels.resetYourPassword,
                    style: context.style.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${labels.passwordResetLinkHasBeenSentAt} ${state.email}",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: SvgPicture.asset(Assets.email),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: FilledButton(
                      onPressed: () {
                        if (Platform.isAndroid) {
                          AndroidIntent intent = const AndroidIntent(
                            action: 'android.intent.action.MAIN',
                            category: 'android.intent.category.APP_EMAIL',
                          );
                          intent.launch();
                        } else if (Platform.isIOS) {
                          //TODO: implement for ios
                        }
                      },
                      child: Text(labels.openEmailApp),
                    ),
                  ),
                ],
              ),
            ),
            const ResetPasswordPage(reset: true),
          ],
        ),
      ),
    );
  }
}
