// ignore_for_file: use_build_context_synchronously, unused_result
import 'package:avahan/features/auth/providers/auth_notifier_provider.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResetPasswordPage extends HookConsumerWidget {
  const ResetPasswordPage({super.key, this.reset = false});

  static const route = "/reset-password";

  final bool reset;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final state = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      appBar: reset
          ? null
          : AppBar(
              title: Text(labels.changeYourPassword),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0).copyWith(top: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                labels.createANewPassword,
                style: context.style.headlineMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                autofocus: true,
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
                  onPressed: state.loading || state.password.length < 8
                      ? null
                      : () async {
                            try {
                              await notifier.updatePassword();
                              context.message(labels.passwordUpdatedSuccessfully);
                              context.go();
                            } catch (e) {
                              context.error(e);
                            
                          }
                        },
                  child: Text(labels.updatePassword),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
