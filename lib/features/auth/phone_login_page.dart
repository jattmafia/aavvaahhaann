// ignore_for_file: use_build_context_synchronously

import 'package:avahan/features/auth/widgets/device_dialog.dart';
import 'package:avahan/features/auth/widgets/resend_view.dart';
import 'package:avahan/features/components/pinput_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/features/auth/providers/auth_notifier_provider.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:otp_autofill/otp_autofill.dart';

class PhoneLoginPage extends HookConsumerWidget {
  const PhoneLoginPage({super.key});

  static const route = "/phone-login";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final state = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);

    final focus = useFocusNode();

    final controller = useTabController(
      initialLength: 2,
    );

    final textController = useTextEditingController();

    final otpController = useRef(
      defaultTargetPlatform != TargetPlatform.android
          ? null
          : OTPTextEditController(
              codeLength: 6,
              onCodeReceive: (v) async {
                textController.text = v;
              },
            )
        ?..startListenUserConsent(
          (code) {
            print(code);
            final exp = RegExp(r'\d{6}');
            print(exp);
            final value = exp.stringMatch(code ?? '') ?? '';
            print(value);
            return value;
          },
          strategies: [],
        ),
    );

    final index = useState(0);

    useEffect(() {
      controller.addListener(() {
        index.value = controller.index;
      });
      return null;
    }, []);
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
                    Text(
                      labels.enterPhoneNumber,
                      style: context.style.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Form(
                      child: TextFormField(
                        autofocus: true,
                        initialValue: state.phoneNumber,
                        onChanged: notifier.phoneNumberChanged,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          helperText: labels.weWillSendYouACodeBySMS,
                          helperMaxLines: 2,
                          prefixText: "+91 ",
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
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
                        onPressed:
                            state.loading || state.phoneNumber.length != 10
                                ? null
                                : () async {
                                    try {
                                      await notifier.sendOtp();
                                      focus.requestFocus();
                                      controller.animateTo(1);
                                    } catch (e) {
                                      context.error(e);
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
                      labels.enterYourCode,
                      style: context.style.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    PinPutField(
                      focusNode: focus,
                      controller: textController,
                      onCompleted: (v) async {
                        try {
                          await notifier.verifyOtp(v);
                          context.message(labels.loggedInSuccessfully);
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
                    ),
                    SizedBox(height: context.size_.height / 20),
                    if (index.value == 1 && state.otpSentAt != null)
                      ResendView(
                        otpSentAt: state.otpSentAt!,
                        resendOTP: notifier.resendOTP,
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
