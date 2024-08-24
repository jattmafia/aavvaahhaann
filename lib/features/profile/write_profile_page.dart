// ignore_for_file: use_build_context_synchronously, unnecessary_string_escapes

import 'package:avahan/features/components/optional_field_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:avahan/features/auth/large_auth_view_wrapper.dart';
import 'package:avahan/features/components/loading_layer.dart';
import 'package:avahan/features/profile/providers/write_profile_notifier.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/validators.dart';

import '../components/bottom_button_wrapper.dart';

class WriteProfilePage extends HookConsumerWidget {
  WriteProfilePage({
    super.key,
    this.profile,
  });
  final formKey = GlobalKey<FormState>();

  static const route = "/write-profile";

  final Profile? profile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final styles = context.style;
    final provider = writeProfileProvider(profile);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    return SizedBox();


  //   final child = LoadingLayer(
  //     loading: state.loading,
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: Text(
  //           labels.enterYourDetails,
  //         ),
  //       ),
  //       bottomNavigationBar: BottomButtonWrapper(
  //         child: FilledButton(
  //           onPressed: notifier.continueToCreate
  //               ? () async {
  //                   if (formKey.currentState!.validate()) {
  //                     try {
  //                       await notifier.write();
  //                       if (profile != null) {
  //                         context.pop(true);
  //                       } else {
  //                         context.go();
  //                       }
  //                     } catch (e) {
  //                       context.error(e);
  //                     }
  //                   }
  //                 }
  //               : null,
  //           child: Text(
  //             labels.continue_,
  //           ),
  //         ),
  //       ),
  //       body: SafeArea(
  //         child: SingleChildScrollView(
  //           padding: const EdgeInsets.all(16),
  //           child: Form(
  //             key: formKey,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  
  //                   Text(
  //                     labels.fullName,
  //                     style: styles.titleSmall,
  //                   ),
  //                   const SizedBox(height: 8),
  //                   TextFormField(
  //                     initialValue: state.profile.name,
  //                     textCapitalization: TextCapitalization.words,
  //                     validator: Validators.required,
  //                     inputFormatters: [
  //                       LengthLimitingTextInputFormatter(100),
  //                       FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
  //                     ],
  //                     onChanged: (value) => notifier.nameChanged(value.trim()),
  //                   ),
  //                   const SizedBox(height: 12),
  //                   OptionalFieldLabel(
  //                     child: Text(
  //                       labels.email,
  //                       style: styles.titleSmall,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 8),
  //                   TextFormField(
  //                     enabled: notifier.emailEnabled,
  //                     initialValue: state.profile.email,
  //                     keyboardType: TextInputType.emailAddress,
  //                     validator: Validators.email,
  //                     onChanged: notifier.emailChanged,
  //                   ),
                  
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   if (profile == null && context.large) {
  //     return LargeAuthViewWrapper(page: child);
  //   }

  //   return child;
  }
}
