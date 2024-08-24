// ignore_for_file: use_build_context_synchronously

import 'package:avahan/admin/components/image_upload_view.dart';
import 'package:avahan/admin/moods/providers/write_moods_notifier.dart';
import 'package:avahan/core/enums/lang.dart';

import 'package:avahan/core/models/mood.dart';
import 'package:avahan/features/components/loading_layer.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/labels.dart';
import 'package:avahan/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WriteMoodPage extends HookConsumerWidget {
  WriteMoodPage({
    super.key,
    this.initial,
  });

  final Mood? initial;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final provider = WriteMoodProvider(initial);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    Future<void> write(bool publish) async {
      if (formKey.currentState!.validate()) {
        if (state.mood.iconEn.isEmpty && state.iconEn == null) {
          context.message("Please upload icon image for English");
          return;
        }
        try {
          await notifier.write(publish);
          context.pop();
        } catch (e) {
          context.error(e);
        }
      }
    }

    return LoadingLayer(
      loading: state.loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(notifier.isEdit ? "Edit Moods" : "Add Moods"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                        child: Text(
                          "Name",
                          style: context.style.titleSmall,
                        ),
                      ),
                      Row(
                        children: Lang.values
                            .map(
                              (lang) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    initialValue: state.mood.nameLang(lang),
                                    decoration: InputDecoration(
                                        hintText: Labels.lang(lang)),
                                    onChanged: (value) {
                                      notifier.nameChanged(value, lang);
                                    },
                                    validator: lang == Lang.en
                                        ? Validators.required
                                        : null,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                        child: Text(
                          "Icon Image",
                          style: context.style.titleSmall,
                        ),
                      ),
                      Row(
                        children: Lang.values
                            .map(
                              (lang) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ImageUploadView(
                                    url: state.mood.iconLang(lang)?.crim,
                                    file: state.icon(lang),
                                    label: "for ${Labels.lang(lang)}",
                                    onFilePicked: (f) {
                                      notifier.iconChanged(f, lang);
                                    },
                                    onUrlChanged: (url) {
                                      notifier.iconUrlChanged(url, lang);
                                    },
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                        child: Text(
                          "Cover Image",
                          style: context.style.titleSmall,
                        ),
                      ),
                      Row(
                        children: Lang.values
                            .map(
                              (lang) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ImageUploadView(
                                    url: state.mood.coverLang(lang)?.crim,
                                    file: state.cover(lang),
                                    label: "for ${Labels.lang(lang)}",
                                    onFilePicked: (f) {
                                      notifier.coverChanged(f, lang);
                                    },
                                    onUrlChanged: (url) {
                                      notifier.coverUrlChanged(url, lang);
                                    },
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                        child: Text(
                          "Description",
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
                                  child: TextFormField(
                                    minLines: 5,
                                    maxLines: 10,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    initialValue:
                                        state.mood.descriptionLang(lang),
                                    decoration: InputDecoration(
                                      hintText:
                                          "Description for ${Labels.lang(lang)}",
                                    ),
                                    onChanged: (value) {
                                      notifier.descriptionChanged(value, lang);
                                    },
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            write(true);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            child: Text("Save"),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
