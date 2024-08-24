// ignore_for_file: use_build_context_synchronously

import 'package:avahan/admin/artists/providers/write_artist_notifier.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/components/image_upload_view.dart';
import 'package:avahan/admin/components/search_view.dart';
import 'package:avahan/core/enums/artist_type.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:avahan/features/components/loading_layer.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/labels.dart';
import 'package:avahan/utils/validators.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WriteArtistPage extends HookConsumerWidget {
  WriteArtistPage({
    super.key,
    this.initial,
  });

  final Artist? initial;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final provider = writeArtistProvider(initial);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

        final categories = ref.watch(adminCategoriesNotifierProvider).categories;


    Future<void> write(bool publish) async {
      if (formKey.currentState!.validate()) {
        if (state.artist.iconEn.isEmpty && state.iconEn == null) {
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
          title: Text(notifier.isEdit ? "Edit Artist" : "Add Artist"),
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
                          "Type",
                          style: context.style.titleSmall,
                        ),
                      ),
                      Row(
                        children: Lang.values
                            .map(
                              (lang) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField<ArtistType>(
                                    value:
                                        state.artist.type == ArtistType.unknown
                                            ? null
                                            : state.artist.type,
                                    items: ArtistType.values
                                        .where((element) =>
                                            element != ArtistType.unknown)
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(context
                                                .locale(lang)
                                                .labelByArtistType(e)),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      notifier.typeChanged(
                                          value ?? ArtistType.unknown);
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Type for ${Labels.lang(lang)}",
                                    ),
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
                                    initialValue: state.artist.nameLang(lang),
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
                                    url: state.artist.iconLang(lang)?.crim,
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
                                    url: state.artist.coverLang(lang)?.crim,
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
                                        state.artist.descriptionLang(lang),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Categories",
                          style: context.style.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 300,
                          child: SearchView(
                            categories: categories
                                .where((element) => !state.artist.categories
                                    .contains(element.id))
                                .toList(),
                            onSelected: notifier.toggleCategory,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: categories
                              .where((element) =>
                                  state.artist.categories.contains(element.id))
                              .map(
                                (e) => Chip(
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: context.scheme.outline,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  labelPadding: EdgeInsets.all(8),
                                  avatar: CircleAvatar(
                                    backgroundImage:
                                        CachedNetworkImageProvider(e.icon()),
                                  ),
                                  label: Text(e.name()),
                                  onDeleted: () {
                                    notifier.toggleCategory(e.id);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            write(false);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            child: Text("Save"),
                          ),
                        ),
                      ),
                      if (!state.artist.active)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilledButton(
                            onPressed: () {
                              write(true);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              child: Text(
                                "Publish",
                              ),
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
