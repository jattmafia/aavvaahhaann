// ignore_for_file: use_build_context_synchronously

import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/location/providers/location_notifier.dart';
import 'package:avahan/features/location/search_city_delegate.dart';
import 'package:avahan/features/location/search_country_delegate.dart';
import 'package:avahan/features/location/search_state_delegate.dart';
import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocationPage extends ConsumerWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final locationAsync = ref.watch(locationNotifierProvider);
    final notifier = ref.read(locationNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await notifier.skip();
                context.go();
              } catch (e) {
                context.error(e);
              }
            },
            child: Text(context.labels.skip),
          ),
        ],
      ),
      body: SafeArea(
        child: AsyncWidget(
          value: locationAsync,
          data: (location) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      key: ValueKey(location.hashCode),
                      children: [
                        Image.asset(Assets.sadhu1, height: 200),
                        const SizedBox(height: 16),
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
                                notifier.countryChanged(
                                    picked.name, picked.iso);
                              }
                            }),
                        const SizedBox(height: 16),
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
                              notifier.stateChanged(picked.name, picked.iso);
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
                              notifier.cityChanged(picked);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0).copyWith(top: 0),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await notifier.write();
                          context.go();
                        } catch (e) {
                          context.error(e);
                        }
                      },
                      child: Text(context.labels.next),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
