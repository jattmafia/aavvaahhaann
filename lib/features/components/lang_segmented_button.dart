import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/providers/cache_provider.dart';
import 'package:avahan/core/providers/lang_provider.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/labels.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class LangSegmentedButton extends ConsumerWidget {
  const LangSegmentedButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SegmentedButton<Lang>(
      showSelectedIcon: false,
      segments: Lang.values
          .map(
            (e) => ButtonSegment<Lang>(
              value: e,
              label: Text(
                Labels.lang(e),
              ),
            ),
          )
          .toList(),
      selected: {
        ref.lang
      },
      onSelectionChanged: (v) {
        ref.watch(langProvider.notifier).state = v.first;
        ref.read(cacheProvider).value?.setLang(v.first);
      },
    );
  }
}
