// ignore_for_file: use_build_context_synchronously

import 'package:avahan/admin/users/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/features/auth/providers/auth_notifier_provider.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/validators.dart';

class AdminLoginPage extends ConsumerWidget {
  AdminLoginPage({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authNotifierProvider);
    final notifier = ref.read(authNotifierProvider.notifier);
    final emails = ref.watch(adminUsersProvider).asData?.value.map((e)=>e.email).toList() ?? []; 
    return Scaffold(
      backgroundColor: context.scheme.surfaceVariant,
      body: Center(
        child: Container(
          height: 574,
          width: 947,
          decoration: BoxDecoration(
            color: context.scheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(blurRadius: 24, color: context.scheme.outlineVariant)
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: context.scheme.surfaceTint.withOpacity(0.05),
                      child: Image.asset(
                        "assets/sadhu2.png",
                        fit: BoxFit.cover,
                      )
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              "assets/logo.png",
                              height: 32,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Welcome To Avahan',
                            style: context.style.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Music is the strongest form of magic.',
                            style: TextStyle(
                              color: context.scheme.outline,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Username',
                            style: context.style.titleSmall,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue:
                                state.email.crim,
                            onChanged: notifier.emailChanged,
                            validator: Validators.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Password',
                            style: context.style.titleSmall,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            obscureText: true,
                            onChanged: notifier.passwordChanged,
                            initialValue: state.password.crim,
                          ),
                          const Spacer(),
                          state.loading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : FilledButton(
                                  onPressed: state.email.isNotEmpty &&
                                          state.password.isNotEmpty && emails.contains(state.email.trim())
                                      ? () async {
                                          try {
                                            await notifier.loginWithEmail();
                                          } catch (e) {
                                            context.error(e);
                                          }
                                        }
                                      : null,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Login'),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
