import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:avahan/utils/extensions.dart';

class ResendView extends StatelessWidget {
  const ResendView(
      {super.key, required this.otpSentAt, required this.resendOTP});

  final DateTime otpSentAt;
  final Future<void> Function() resendOTP;
  @override
  Widget build(BuildContext context) {
    final labels = context.labels;
  

    return StreamBuilder<int>(
      stream: Stream.periodic(
        const Duration(seconds: 1),
        (computationCount) => computationCount,
      ),
      builder: (context, snapshot) {
        final duration = DateTime.now().difference(otpSentAt);
        final remainSecs = 30 - duration.inSeconds;
        return remainSecs > 1
            ? Text(
                labels.didntReceiveInSec(remainSecs),
                style: context.style.labelLarge!.copyWith(
                  color: context.scheme.outline,
                ),
              )
            : RichText(
                text: TextSpan(
                  text: "",
                  children: labels.didntReceive
                      .split('|')
                      .map(
                        (e) => TextSpan(
                            text: "$e ",
                            style: [labels.requestAgain].contains(e)
                                ? context.style.labelLarge!.copyWith(
                                    color: context.scheme.primary,
                                  )
                                : context.style.labelLarge!
                                    .copyWith(color: context.scheme.outline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                if ([labels.requestAgain].contains(e)) {
                                  try {
                                    await resendOTP();
                                    context.message('OTP resent!');
                                  } catch (e) {
                                    context.error(e);
                                  }
                                }
                              }),
                      )
                      .toList(),
                ),
              );
      },
    );
  }
}
