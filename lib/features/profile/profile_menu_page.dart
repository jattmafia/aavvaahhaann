// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:avahan/config.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:avahan/features/auth/change_email_page.dart';
import 'package:avahan/features/components/lang_button.dart';
import 'package:avahan/features/components/web_page.dart';
import 'package:avahan/features/dashboard/providers/dashboard_provider.dart';
import 'package:avahan/features/profile/settings_page.dart';
import 'package:avahan/features/subscriptions/providers/premium_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/features/auth/providers/auth_notifier_provider.dart';
import 'package:avahan/features/components/svg_icon.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileMenuPage extends ConsumerWidget {
  const ProfileMenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    final labels = context.labels;
    final styles = context.style;
    final profile = ref.watch(yourProfileProvider).value!;

    final googlePremium = ref.watch(googlePremiumProvider);
    final premium = ref.watch(premiumProvider);

    final masterData = ref.read(masterDataProvider).value!;
    return Scaffold(
      backgroundColor:
          context.large ? context.scheme.surface.withOpacity(0.5) : null,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(labels.profile),
        actions: const [LangButton()],
        leading: BackButton(
          onPressed: () {
            ref.read(dashboardNotifierProvider.notifier).setIndex(0);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              CircleAvatar(
                backgroundColor: context.scheme.primaryContainer,
                radius: 40,
                child: Text(
                  profile.name
                      .split(' ')
                      .where((element) => element.isNotEmpty)
                      .map((e) => e.characters.first)
                      .join(),
                  style: styles.titleLarge!.copyWith(
                    color: context.scheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ), // Provide the image asset
              Text(
                profile.name,
                style: styles.titleMedium,
              ),
              if (profile.isGuest) ...[
                const SizedBox(
                  height: 16,
                ),
                FilledButton(
                  onPressed: () async {
                    ref.authorized(ref, () {});
                  },
                  child: Text(
                    labels.signInSignUp,
                  ),
                ),
              ],
              const SizedBox(
                height: 4,
              ),
              GestureDetector(
                onTap: () {
                  ref.push(ChangeEmailPage.route);
                },
                child: Text(
                  profile.phoneNumber ?? profile.email ?? '',
                  style: styles.labelLarge!.copyWith(
                    color: context.scheme.outline,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              if (profile.lifetime)
                ListTile(
                  leading: Image.asset(
                    Assets.premium,
                    height: 24,
                    width: 24,
                  ),
                  title: Text(
                    labels.lifeTime,
                  ),
                  subtitle: Text(labels.youHaveLifetimeAccessToPremiumFeatures),
                )
              else if (premium.value == true ||
                  (profile.premium && profile.oldPurchase))
                ListTile(
                  onTap: googlePremium.value == true
                      ? () {
                          launchUrlString(Config.appSubscriptionsLink);
                        }
                      : null,
                  leading: Image.asset(
                    Assets.premium,
                    height: 24,
                    width: 24,
                  ),
                  title: Text(labels.premium),
                  subtitle: googlePremium.value == false &&
                          profile.oldPurchase &&
                          profile.expiryAt != null
                      ? Text(
                          profile.expired
                              ? labels.expiredOn(profile.expiryAt!.dateLabel3)
                              : labels
                                  .willExpireOn(profile.expiryAt!.dateLabel3),
                        )
                      : null,
                  trailing: googlePremium.value == true
                      ? const Icon(Icons.keyboard_arrow_right_rounded)
                      : null,
                )
              else if (!profile.premium)
                ListTile(
                    leading: null,
                    title: Text(labels.freeTrial),
                    // subtitle: profile.expiryAt != null
                    //     ? Text(
                    //         profile.expired
                    //             ? labels.expiredOn(profile.expiryAt!.dateLabel3)
                    //             : labels
                    //                 .willExpireOn(profile.expiryAt!.dateLabel3),
                    //       )
                    //     : null
                        ),

              //               else if (premium.value == true || (!profile.premium && !profile.expired))
              // ListTile(
              //   onTap: (!profile.oldPurchase && premium.value!)
              //       ? () {
              //           launchUrlString(Config.appSubscriptionsLink);
              //         }
              //       : null,
              //   leading: const Icon(Icons.workspace_premium_rounded),
              //   title:
              //       Text(premium.value! ? labels.premium : labels.freeTrial),
              //   subtitle: (profile.oldPurchase || !profile.premium) &&
              //           profile.expiryAt != null
              //       ? Text(
              //           labels.willExpireOn(profile.expiryAt!.dateLabel3),
              //         )
              //       : null,
              //   trailing: premium.value! && !profile.oldPurchase
              //       ? const Icon(Icons.keyboard_arrow_right_rounded)
              //       : null,
              // ),
              ListTile(
                onTap: () {
                  ref.push(SettingsPage.route);
                },
                title: Text(labels.settings),
                subtitle: Text(labels.manageProfilePasswordAndMore),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              ),
              ListTile(
                onTap: () {
                  launchUrlString(Config.appLink);
                },
                title: Text(labels.rateApp),
                subtitle: Text(labels.loveTheAppRateUsOnThePlayStore),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              ),
              ListTile(
                onTap: () {
                  Share.share(
                      "${masterData.appShareMessage}\n${Config.appLink}");
                },
                title: Text(labels.shareApp),
                subtitle: Text(labels.shareTheAppWithYourFriendsAndFamily),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              ),
              ListTile(
                onTap: () {
                  ref.push(
                    WebPage.route,
                    extra: MapEntry(
                      labels.aboutUs,
                      lang == Lang.hi
                          ? masterData.aboutHiUrl
                          : masterData.aboutEnUrl,
                    ),
                  );
                },
                title: Text(labels.aboutUs),
                subtitle: Text(labels.knowMoreAboutAvahan),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              ),
              ListTile(
                onTap: () {
                  ref.push(
                    WebPage.route,
                    extra: MapEntry("Terms of Use", masterData.termsUrl),
                  );
                },
                title: Text(labels.termsOfUse),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              ),
              ListTile(
                onTap: () {
                  ref.push(
                    WebPage.route,
                    extra: MapEntry("Privacy Policy", masterData.privacyUrl),
                  );
                },
                title: Text(labels.privacyPolicy),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              ),
              ListTile(
                onTap: () {
                  ref.authorized(ref, () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (masterData.contactEmail.isNotEmpty)
                              ListTile(
                                onTap: () async {
                                  final Email email = Email(
                                    body: "",
                                    subject:
                                        'Hello Avahan Team, I am ${profile.name}',
                                    recipients: [masterData.contactEmail],
                                    isHTML: false,
                                  );
                                  await FlutterEmailSender.send(email);
                                },
                                leading: const Icon(
                                  Icons.email_outlined,
                                ),
                                title: Text(labels.email),
                                trailing: const Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                ),
                              ),
                            if (masterData.contactPhone.isNotEmpty)
                              ListTile(
                                onTap: () {
                                  launchUrlString(
                                    "whatsapp://send?phone=${masterData.contactPhone}&text=Hello Avahan Team, I am ${profile.name}.\n",
                                  );
                                },
                                leading: SvgPicture.asset(
                                  Assets.whatsapp,
                                  height: 28,
                                  width: 28,
                                ),
                                title: const Text("WhatsApp"),
                                trailing: const Icon(
                                    Icons.keyboard_arrow_right_rounded),
                              ),
                          ],
                        ),
                      ),
                    );
                  });
                },
                title: Text(labels.helpSupport),
                subtitle: Text(labels.getInTouchWithAvahanIfYouNeedAnyHelp),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              ),
              if (!profile.isGuest && Platform.isIOS) ...[
                HookConsumer(builder: (context, ref, child) {
                  final loading = useState(false);
                  return ListTile(
                    onTap: loading.value
                        ? null
                        : () async {
                            final value = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete your account'),
                                content: const Text(
                                  'Are you sure you want to delete your account?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                            if (value == true) {
                              loading.value = true;
                              try {
                                await ref
                                    .read(authNotifierProvider.notifier)
                                    .deleteAccount();
                              } catch (e) {
                                loading.value = true;
                                context.error(e);
                              }
                            }
                          },
                    title: const Text('Delete your account'),
                    trailing: loading.value
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.keyboard_arrow_right_rounded),
                  );
                }),
              ],
              const SizedBox(
                height: 56,
              ),
              if (!profile.isGuest)
                Center(
                  child: HookConsumer(
                    builder: (context, ref, child) {
                      final loading = useState(false);

                      final notifier = ref.read(authNotifierProvider.notifier);
                      return loading.value
                          ? const CircularProgressIndicator()
                          : TextButton.icon(
                              onPressed:  () async {
                                loading.value = true;
                                try {
                                  await notifier.logout();
                                  ref.go();
                                } catch (e) {
                                  loading.value = false;
                                  context.error(e);
                                }
                              },
                              label: Text(labels.logout),
                              icon: const SvgIcon(
                                IconAssets.logout,
                                size: 20,
                              ),
                            );
                    },
                  ),
                ),
              const SizedBox(
                height: 160,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
