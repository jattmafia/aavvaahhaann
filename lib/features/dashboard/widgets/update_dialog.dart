import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:avahan/utils/assets.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../config.dart';

class VersionUpdateDialog extends StatelessWidget {
  const VersionUpdateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labels = context.labels;
    return UpdateView(
      title: labels.hiThere,
      subtitle: labels.appUpdateRequired,
      description: labels.youNeedToUpdateTheApp,
      later: true,
    );
  }
}

class ForceVersionUpdateDialog extends StatelessWidget {
  const ForceVersionUpdateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labels = context.labels;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return PopScope(
      canPop: false,
      child: UpdateView(
        title: labels.updateAvilable,
        subtitle: labels.youAreUsingAnOlderVersion,
        later: false,
        description: labels.yourCurrentAppVersionIsNoLongerSupported,
      ),
    );
  }
}

class UpdateView extends StatelessWidget {
  const UpdateView(
      {super.key,
      required this.title,
      required this.description,
      required this.later,
      required this.subtitle});

  final String title;
  final String subtitle;
  final String description;
  final bool later;

  @override
  Widget build(BuildContext context) {
    final labels = context.labels;
    return Dialog(
      child: Stack(
        children: [
          Positioned(
            top: -48,
            right: -48,
            child: SvgPicture.asset(
              Assets.update,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.style.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  style: context.style.titleMedium!.copyWith(
                    color: context.scheme.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: TextStyle(
                    color: context.scheme.outline,
                  ),
                ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: () {
                    launchUrlString(
                      Config.appLink,
                      mode: LaunchMode.externalNonBrowserApplication,
                    );
                    if (later) {
                      context.pop();
                    }
                  },
                  child: Text(labels.updateNow),
                ),
                if (later)
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      labels.noIwillUpdateLater,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
