// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/features/auth/providers/auth_notifier_provider.dart';
import 'package:avahan/utils/extensions.dart';

class CreateAccountPage extends HookConsumerWidget {
  const CreateAccountPage({super.key});

  static const route = "/sign-up";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final state = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);

    final focus = useFocusNode();

    final emailFormKey = useState(GlobalKey<FormState>());

    final controller = useTabController(
      initialLength: 3,
    );

    useOnAppLifecycleStateChange((previous, current) {
      if (previous != AppLifecycleState.resumed &&
          current == AppLifecycleState.resumed &&
          controller.index == 2 &&
          state.email.isNotEmpty &&
          state.password.isNotEmpty) {
        notifier.loginWithEmail().whenComplete(() {
          context.go();
        }).catchError((e) {
          debugPrint("$e");
        });
      }
    });

    final index = useState(0);

    useEffect(() {
      controller.addListener(() {
        index.value = controller.index;
      });
      return null;
    }, []);

    void login() async {
      try {
        await notifier.loginWithEmail();
        context.go();
      } catch (e) {
        context.error(e);
      }
    }

    return PopScope(
      canPop: index.value == 0,
      onPopInvoked: (value) async {
        if (controller.index != 0) {
          controller.animateTo(controller.index - 1);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(labels.createAccount),
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
                    Text(labels.whatsYourEmailAddress,
                        style: context.style.headlineMedium),
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
                            : () {
                                if (emailFormKey.value.currentState!
                                    .validate()) {
                                  focus.requestFocus();
                                  controller.animateTo(1);
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
                      labels.createApassword,
                      style: context.style.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      focusNode: focus,
                      initialValue: state.password,
                      onChanged: notifier.passwordChanged,
                      validator: Validators.required,
                      obscureText: state.obscurePassword,
                      decoration: InputDecoration(
                        helperText: labels.useAtleast,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            notifier.togglePasswordVisibility();
                          },
                          icon: Icon(
                            state.obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
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
                        onPressed: !state.loading && state.password.length >= 8
                            ? () async {
                                try {
                                  final v = await notifier.createAccount();
                                  if (v) {
                                    login();
                                  } else {
                                    controller.animateTo(2);
                                  }
                                } catch (e) {
                                  context.error(e);
                                }
                              }
                            : null,
                        child: Text(labels.next),
                      ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0).copyWith(top: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      labels.verifyYourEmail,
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
                                flags: [Flag.FLAG_ACTIVITY_NEW_TASK]);
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
                          login();
                        },
                        child: Text(labels.done),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
