// ignore_for_file: use_build_context_synchronously

import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/components/bottom_button_wrapper.dart';
import 'package:avahan/features/components/loading_layer.dart';
import 'package:avahan/features/location/providers/location_notifier.dart';
import 'package:avahan/features/location/search_city_delegate.dart';
import 'package:avahan/features/location/search_country_delegate.dart';
import 'package:avahan/features/location/search_state_delegate.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/utils/dates.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnterRemainingDetailsPage extends HookConsumerWidget {
  const EnterRemainingDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final profile = ref.read(yourProfileProvider).value!;

    final dateOfBirth =
        useState(profile.dateOfBirth ?? DateTime(Dates.now.year - 18));

    final loading = useState(false);

    return LoadingLayer(
      loading: loading.value,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: const [
            CloseButton(),
          ],
        ),
        bottomNavigationBar: BottomButtonWrapper(
          child: FilledButton(
            onPressed: () async {
              try {
                loading.value = true;
                await ref.read(profileRepositoryProvider).updateInfo(
                      profile.id,
                      (profile.city == null || profile.state == null
                          ? ref.read(locationNotifierProvider).asData?.value
                          : null),
                      dateOfBirth.value,
                    );
                ref.refresh(yourProfileProvider);
                context.pop();
              } catch (e) {
                loading.value = false;
                context.error(e);
              }
            },
            child: Text(labels.save),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                labels.completeYourProfile,
                style: context.style.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                labels.yourDateOfBirth(
                  [
                    if (profile.dateOfBirth == null) labels.dateOfBirthFormat,
                    if (profile.city == null || profile.state == null)
                      labels.cityState,
                  ].join(" ${labels.and} "),
                ),
              ),
              if (profile.dateOfBirth == null) ...[
                const SizedBox(height: 16),
                Text(
                  labels.dateOfBirth,
                  style: context.style.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: dateOfBirth.value,
                    onDateTimeChanged: (v) {
                      dateOfBirth.value = v;
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (profile.state == null || profile.city == null)
                Consumer(
                  builder: (context, ref, child) {
                    final locationAsync = ref.watch(locationNotifierProvider);
                    final locationNotifier =
                        ref.read(locationNotifierProvider.notifier);
                    return AsyncWidget(
                      value: locationAsync,
                      data: (location) {
                        return Column(
                          key: ValueKey(location.hashCode),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (location.country == null) ...[
                              Text(
                                labels.country,
                                style: context.style.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                style: context.style.titleLarge,
                                initialValue: location.country,
                                readOnly: true,
                                onTap: () async {
                                  final picked = await showSearch(
                                      context: context,
                                      delegate: SearchCountryDelegate());
                                  if (picked != null) {
                                    locationNotifier.countryChanged(
                                        picked.name, picked.iso);
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                            Text(
                              labels.state,
                              style: context.style.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              enabled: location.isoCode != null,
                              style: context.style.titleLarge,
                              initialValue: location.state,
                              readOnly: true,
                              onTap: () async {
                                final picked = await showSearch(
                                    context: context,
                                    delegate:
                                        SearchStateDelegate(location.isoCode!));
                                if (picked != null) {
                                  locationNotifier.stateChanged(
                                      picked.name, picked.iso);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              labels.city,
                              style: context.style.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              enabled: location.isoCode != null &&
                                  location.stateCode != null,
                              style: context.style.titleLarge,
                              initialValue: location.city,
                              readOnly: true,
                              onTap: () async {
                                final picked = await showSearch(
                                  context: context,
                                  delegate: SearchCityDelegate(
                                    location.isoCode!,
                                    location.stateCode!,
                                  ),
                                );
                                if (picked != null) {
                                  locationNotifier.cityChanged(picked);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
