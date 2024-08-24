// ignore_for_file: use_build_context_synchronously

import 'package:avahan/core/enums/gender.dart';
import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:avahan/features/components/web_page.dart';
import 'package:avahan/features/profile/providers/write_profile_notifier.dart';
import 'package:avahan/utils/dates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/utils/extensions.dart';

class CreateProfilePage extends HookConsumerWidget {
  const CreateProfilePage({super.key});

  static const route = "/sign-up";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterdata = ref.read(masterDataProvider).value!;
    final labels = context.labels;
    final provider = writeProfileProvider(null);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    final controller = useTabController(initialLength: 3);

    final index = useState(0);

    final dateOfBirth =
        notifier.profile?.dateOfBirth ?? DateTime(Dates.now.year - 18);

    useEffect(() {
      controller.addListener(() {
        index.value = controller.index;
      });
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(
        title: Text(labels.createAccount),
        leading: index.value == 0
            ? null
            : BackButton(
                onPressed: () {
                  controller.animateTo(controller.index - 1);
                },
              ),
        actions: [
          if (index.value == 0)
            TextButton(
              onPressed: () {
                notifier.dateOfBirthChanged(null);
                controller.animateTo(controller.index + 1);
              },
              child: Text(labels.skip),
            ),
          if (index.value == 1)
            TextButton(
              onPressed: () {
                notifier.genderChanged(null);
                controller.animateTo(controller.index + 1);
              },
              child: Text(labels.skip),
            ),
        ],
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
                    labels.whatsYourDateOfBirth,
                    style: context.style.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: dateOfBirth,
                      onDateTimeChanged: (v) {
                        print("1. $v");
                        notifier.dateOfBirthChanged(v);
                      },
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
                      onPressed: state.loading
                          ? null
                          : () {
                              notifier.dateOfBirthChanged(
                                  state.profile.dateOfBirth ?? dateOfBirth);
                              controller.animateTo(controller.index + 1);
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
                    labels.whatsYourGender,
                    style: context.style.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      Gender.female,
                      Gender.male,
                      Gender.nonBinary,
                      Gender.other,
                      Gender.preferNotToSay,
                    ]
                        .map(
                          (e) => ChoiceChip(
                            label: Text(
                              labels.labelByGender(e),
                            ),
                            selected: state.profile.gender == e,
                            onSelected: (v) {
                              notifier.genderChanged(e);
                            },
                          ),
                        )
                        .toList(),
                  ),
                  //// Female, Male, Non-binary, Other, Prefer not to say
                  const SizedBox(height: 16),
                  Center(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      onPressed: state.loading ||
                              state.profile.gender == Gender.unknown
                          ? null
                          : () {
                              controller.animateTo(controller.index + 1);
                            },
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
                    labels.whatsYourName,
                    style: context.style.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    autofocus: true,
                    initialValue: state.profile.name,
                    onChanged: (v) => notifier.nameChanged(v.trim()),
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    ],
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      text: labels.byTappingYouAgreeToCreateAccount,
                      style: context.style.bodySmall,
                      children: [
                        TextSpan(
                          text: labels.avahanTermsOfUse,
                          style: context.style.bodySmall!.copyWith(
                            color: context.scheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push(WebPage.route,
                                  extra: MapEntry(labels.avahanTermsOfUse,
                                      masterdata.termsUrl));
                            },
                        ),
                        const TextSpan(
                          text: ".",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  ///TODO
                  RichText(
                    text: TextSpan(
                      text: labels.toLearnMoreAboutAvahan,
                      style: context.style.bodySmall,
                      children: [
                        TextSpan(
                          text: labels.avahanPrivacypolicy,
                          style: context.style.bodySmall!.copyWith(
                            color: context.scheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push(WebPage.route,
                                  extra: MapEntry(labels.avahanPrivacypolicy,
                                      masterdata.privacyUrl));
                            },
                        ),
                        const TextSpan(
                          text: ".",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 56),
                  Center(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      onPressed: state.loading || state.profile.name.isEmpty
                          ? null
                          : () async {
                              try {
                                await notifier.write();
                                context.go();
                              } catch (e) {
                                context.error(e);
                              }
                            },
                      child: Text(labels.createAccount),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
