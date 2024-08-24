// ignore_for_file: use_build_context_synchronously

import 'package:avahan/admin/components/image_upload_view.dart';
import 'package:avahan/admin/components/search_view.dart';
import 'package:avahan/admin/playlist/providers/write_playlist_notifier.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/playlist.dart';
import 'package:avahan/features/components/loading_layer.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/labels.dart';
import 'package:avahan/utils/validators.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WritePlaylistPage extends HookConsumerWidget {
  WritePlaylistPage({
    super.key,
    this.initial,
  });

  final Playlist? initial;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final provider = writePlaylistProvider(initial);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    final tracks = ref.watch(adminTracksNotifierProvider).tracks;

    final tagsFocusNode = useFocusNode();

    final tagController = useTextEditingController();

    Future<void> write(bool publish) async {
      if (formKey.currentState!.validate()) {
        if (state.playlist.iconEn.isEmpty && state.iconEn == null) {
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
          title: Text(notifier.isEdit ? "Edit Playlist" : "Add Playlist"),
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
                                    initialValue: state.playlist.nameLang(lang),
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
                                    url: state.playlist.iconLang(lang)?.crim,
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
                                    url: state.playlist.coverLang(lang)?.crim,
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
                                        state.playlist.descriptionLang(lang),
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
                          "Tracks",
                          style: context.style.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 300,
                          child: SearchView(
                            tracks: tracks
                                .where((element) => !state.playlist.tracks
                                    .contains(element.id))
                                .toList(),
                            onSelected: notifier.toggleTrack,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tracks
                              .where((element) =>
                                  state.playlist.tracks.contains(element.id))
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
                                    notifier.toggleTrack(e.id);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tags",
                          style: context.style.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            focusNode: tagsFocusNode,
                            controller: tagController,
                            decoration: const InputDecoration(
                              hintText: "Enter tag here",
                            ),
                            onFieldSubmitted: (value) {
                              notifier.toggleTag(value);
                              tagController.clear();
                              tagsFocusNode.requestFocus();
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: state.playlist.tags
                              .map(
                                (e) => Chip(
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: context.scheme.outline,
                                    ),
                                  ),
                                  label: Text(e),
                                  onDeleted: () {
                                    notifier.toggleTag(e);
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
                      if (!state.playlist.active)
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
