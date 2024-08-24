import 'package:avahan/core/providers/internet_connection_provider.dart';
import 'package:avahan/features/cache/cache_tracks_page.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';




class InternetTile extends StatelessWidget {
  const InternetTile({
    super.key,
    this.showAction = true,
  });

  final bool showAction;

  @override
  Widget build(BuildContext context) {
    final labels = context.labels;

    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(internetConnectionProvider).when(
              data: (data) {
                return !data
                    ? Material(
                        color: context.scheme.onErrorContainer,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  labels.noInternetConnection,
                                  style: context.style.bodySmall!.copyWith(
                                    color: context.scheme.errorContainer,
                                  ),
                                ),
                              ),
                            ),
                            if (showAction)
                              GestureDetector(
                                onTap: () {
                                  context.push(CacheTracksPage.route);
                                },
                                child: Container(
                                  color: context.scheme.onErrorContainer,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        labels.goToDownloads,
                                        style:
                                            context.style.labelMedium?.copyWith(
                                          color: context.scheme.surface,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 16,
                                        color: context.scheme.surface,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink();
              },
              error: (error, stackTrace) => const SizedBox(),
              loading: () => const SizedBox(),
            );
      },
    );
  }
}
