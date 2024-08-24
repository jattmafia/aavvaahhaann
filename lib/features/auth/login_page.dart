// ignore_for_file: use_build_context_synchronously

import 'package:avahan/features/auth/forgot_password_page.dart';
import 'package:avahan/features/auth/widgets/device_dialog.dart';
import 'package:avahan/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/features/auth/providers/auth_notifier_provider.dart';
import 'package:avahan/utils/extensions.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  static const route = "/login";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final state = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);

    final emailFormKey = useState(GlobalKey<FormState>());

    final controller = useTabController(
      initialLength: 2,
    );

    final index = useState(0);

    useEffect(() {
      controller.addListener(() {
        index.value = controller.index;
      });
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              labels.email,
              style: context.style.headlineMedium,
            ),
            const SizedBox(
              height: 8,
            ),
            Form(
              key: emailFormKey.value,
              child: TextFormField(
                autofocus: true,
                initialValue: state.email,
                onChanged: notifier.emailChanged,
                validator: Validators.email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              labels.password,
              style: context.style.headlineMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: state.password,
              onChanged: notifier.passwordChanged,
              validator: Validators.required,
              obscureText: state.obscurePassword,
              decoration: InputDecoration(
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
                onPressed: !state.loading && state.password.length >= 8 && state.email.isNotEmpty
                    ? () async {
                        if(emailFormKey.value.currentState!.validate()){
                          try {
                            await notifier.loginWithEmail();
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
                        }
                      }
                    : null,
                child: Text(labels.login),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                   context.replace(ForgotPasswordPage.route);
                },
                child: Text(labels.forgotPassword),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
