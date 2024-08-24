import 'package:avahan/features/auth/change_email_page.dart';
import 'package:avahan/features/auth/change_phone_page.dart';
import 'package:avahan/features/auth/providers/session_provider.dart';
import 'package:avahan/features/auth/reset_password_page.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const route = "/settings";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;

    final user = ref.read(sessionProvider)!.user;

    print(user.userMetadata);
    return Scaffold(
      appBar: AppBar(
        title: Text(labels.settings),
      ),
      body: ListView(
        children: [
          if (user.email?.crim != null || (user.phone?.crim == null && user.email?.crim == null))
            ListTile(
              title: Text(labels.changeEmail),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {
                context.replace(ChangeEmailPage.route);
              },
            ),
          if (user.email?.crim != null)
            ListTile(
              title: Text(labels.changePassword),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {
                context.replace(ResetPasswordPage.route);
              },
            ),
          if (user.phone?.crim != null)
            ListTile(
              title: Text(labels.changePhoneNumber),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {
                context.replace(ChangePhonePage.route);
              },
            ),
        ],
      ),
    );
  }
}
