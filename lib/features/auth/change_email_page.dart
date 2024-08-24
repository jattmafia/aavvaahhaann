// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:avahan/features/auth/providers/auth_notifier_provider.dart';
import 'package:avahan/features/auth/providers/session_provider.dart';
import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangeEmailPage extends HookConsumerWidget {
  const ChangeEmailPage({super.key});

  static const route = "/change-email";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailFormKey = useState(GlobalKey<FormState>());
    final labels = context.labels;
    final state = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);

    final previousEmail = useRef(ref.read(sessionProvider)!.user.email);

    final controller = useTabController(
      initialLength: 3,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(labels.changeYourEmail),
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
                      labels.enterYourNewEmailAddress,
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
                        decoration: InputDecoration(
                          helperText: labels.youNeedToConfirmEmailLater,
                        ),
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
                                if (emailFormKey.value.currentState!
                                    .validate()) {
                                  try {
                                    await notifier.changeEmail();
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
                      labels.verifyYourPreviousEmail,
                      style: context.style.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      labels.weSentYouAnEmail(previousEmail.value!),
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
                    const SizedBox(height: 16),
                    Center(
                      child: OutlinedButton(
                        onPressed: () async {
                          controller.animateTo(2);
                        },
                        child: Text(labels.done),
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
                      labels.verifyYourNewEmail,
                      style: context.style.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      labels.weSentYouAnEmail(state.email),
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
                    const SizedBox(height: 16),
                    Center(
                      child: OutlinedButton(
                        onPressed: () async {
                          await notifier.refresh();
                          final value = ref.refresh(sessionProvider);
                          if (value?.user.email == state.email) {
                            context.message(labels.emailChangedSuccessfully);
                          } else {
                            context.error(labels.emailNotChanged);
                          }
                          context.pop();
                        },
                        child: Text(labels.done),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
