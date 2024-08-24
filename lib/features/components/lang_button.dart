import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/providers/cache_provider.dart';
import 'package:avahan/core/providers/messaging_provider.dart';
import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/providers/lang_provider.dart';
import '../../utils/labels.dart';

class LangButton extends ConsumerWidget {
  const LangButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final uid = ref.read(yourProfileProvider).asData?.value.id;
    return PopupMenuButton(
      icon: const Icon(Icons.language_rounded),
      onSelected: (v) {
        ref.read(langProvider.notifier).state = v;
        ref.read(cacheProvider).value?.setLang(v);
        if(uid != null){
          final messaging = ref.read(messagingProvider);
          messaging.unsubscribeFromTopic(Lang.values.where((element) => element != v).first.name);
          messaging.subscribeToTopic(v.name);
          ref.read(profileRepositoryProvider).langUpdate(uid, v);
        }
      },
      itemBuilder: (context) {
        return Lang.values
            .map(
              (e) => PopupMenuItem(
                value: e,
                child: Text(
                  Labels.lang(e),
                  style: TextStyle(
                    color: ref.read(langProvider) == e
                        ? context.scheme.primary
                        : null,
                  ),
                ),
              ),
            )
            .toList();
      },
    );
    // return DropdownButtonHideUnderline(
    //   child: DropdownButton<Lang>(
    //     value: ref.lang,
    //     underline: const SizedBox(),
    //     icon: const Icon(Icons.keyboard_arrow_down_rounded),
    //     items: Lang.values
    //         .map(
    //           (e) => DropdownMenuItem<Lang>(
    //             value: e,
    //             child: Text(
    //               Labels.lang(e),
    //             ),
    //           ),
    //         )
    //         .toList(),
    //     onChanged: (v) {
    //       ref.read(langProvider.notifier).state = v!;
    //       ref.read(cacheProvider).value?.setLang(v);
    //     },
    //   ),
    // );
  }
}
