// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:avahan/admin/settings/models/pages_state.dart';
import 'package:avahan/admin/settings/providers/pages_notifier.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/datetime_slot.dart';
import 'package:avahan/core/providers/pages_data_provider.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/components/loading_layer.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/labels.dart';
import 'package:avahan/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';

class PagesPage extends HookConsumerWidget {
  const PagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Pages'),
      ),
      body: AsyncWidget(
        value: ref.watch(pagesDataProvider),
        data: (data) {
          final provider = pagesNotifierProvider(data);
          final state = ref.watch(provider);
          final notifier = ref.read(provider.notifier);
          return LoadingLayer(
            loading: state.loading,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Terms & Conditions",
                            style: context.style.titleSmall,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: Lang.values
                              .map(
                                (lang) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: QuillField(
                                      lang: lang,
                                      initial: state.pagesData.tcLang(lang)?.crim,
                                      onChanged: (value) {
                                        notifier.tcChanged(value, lang);
                                      },
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Privacy & Policy",
                            style: context.style.titleSmall,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: Lang.values
                              .map(
                                (lang) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: QuillField(
                                      lang: lang,
                                      initial: state.pagesData.privacyLang(lang)?.crim,
                                      onChanged: (value) {
                                        notifier.privacyChanged(value, lang);
                                      },
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "About Us",
                            style: context.style.titleSmall,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: Lang.values
                              .map(
                                (lang) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: QuillField(
                                      lang: lang,
                                      initial:
                                          state.pagesData.aboutLang(lang)?.crim,
                                      onChanged: (value) {
                                        notifier.aboutChanged(value, lang);
                                      },
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  if (notifier.savable)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FilledButton(
                          onPressed: () async {
                            try {
                              await notifier.save();
                            } catch (e) {
                              context.error(e);
                            }
                          },
                          child: const Text("Save"),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuillField extends StatelessWidget {
  const QuillField({
    super.key,
    required this.initial,
    required this.onChanged,
    this.lang = Lang.en,
  });
  final Lang lang;
  final String? initial;
  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return HookConsumer(builder: (context, ref, child) {
      final controller = useRef(
        QuillController(
          document: initial != null
              ? Document.fromDelta(Delta.fromJson(
                  jsonDecode(initial!),
                ))
              : Document(),
          selection: const TextSelection.collapsed(offset: 0),
        ),
      );
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: context.scheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: context.scheme.surfaceTint.withOpacity(0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(Labels.lang(lang)),
                  ),
                  QuillToolbar.simple(
                    configurations: QuillSimpleToolbarConfigurations(
                      controller: controller.value,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 332,
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: controller.value,
                  onTapOutside: (event, focusNode) {
                    focusNode.unfocus();
                    onChanged(jsonEncode(
                        controller.value.document.toDelta().toJson()));
                  },
                  scrollable: true,
                  padding: const EdgeInsets.all(16),
                  maxHeight: 300,
                ),
              ),
            ),

            // TextFormField(
            //   textCapitalization: TextCapitalization.words,
            //   initialValue: state.pagesData.tcLang(lang),
            //   decoration: InputDecoration(
            //       hintText: Labels.lang(lang)),
            //   onChanged: (value) {
            //     notifier.tcChanged(value, lang);
            //   },
            //   validator: lang == Lang.en
            //       ? Validators.required
            //       : null,
            // ),
          ],
        ),
      );
    });
  }
}

class DateTimeSlotTile extends StatelessWidget {
  const DateTimeSlotTile(
      {super.key, required this.slot, required this.onRemove});

  final VoidCallback onRemove;
  final DateTimeSlot slot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(slot.start.dateTimeLabel),
        const SizedBox(width: 16),
        Text(
          "To",
          style: TextStyle(
            color: context.scheme.outline,
          ),
        ),
        const SizedBox(width: 16),
        Text(slot.end.dateTimeLabel),
        const SizedBox(width: 16),
        IconButton(
          onPressed: () {
            onRemove();
          },
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}
