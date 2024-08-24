// ignore_for_file: use_build_context_synchronously

import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/components/audio_upload_view.dart';
import 'package:avahan/admin/components/image_upload_view.dart';
import 'package:avahan/admin/components/search_view.dart';
import 'package:avahan/admin/moods/providers/moods_notifier.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/admin/tracks/providers/write_track_notifier.dart';

import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:avahan/features/components/loading_layer.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/labels.dart';
import 'package:avahan/utils/validators.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WriteTrackPage extends HookConsumerWidget {
  WriteTrackPage({
    super.key,
    this.initial,
  });

  final Track? initial;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.labels;
    final provider = writeTrackProvider(initial);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    final groupIds = ref.watch(masterDataProvider).asData?.value.groupIds ?? [];

    final artists = ref.watch(adminArtistsNotifierProvider).artists;
    final categories = ref.watch(adminCategoriesNotifierProvider).categories;
    final moods = ref.watch(adminMoodsNotifierProvider).moods;

    final tagController = useTextEditingController();

    Future<void> write(bool publish) async {
      if (formKey.currentState!.validate()) {
        if (state.track.iconEn.isEmpty && state.iconEn == null) {
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
          title: Text(notifier.isEdit ? "Edit Track" : "Add Track"),
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
                                    initialValue: state.track.nameLang(lang),
                                    decoration: InputDecoration(
                                        hintText: Labels.lang(lang)),
                                    onChanged: (value) {
                                      notifier.nameChanged(value.trim(), lang);
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
                                    url: state.track.iconLang(lang)?.crim,
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
                                    url: state.track.coverLang(lang)?.crim,
                                    file: state.cover(lang),
                                    label: "for ${Labels.lang(lang)}",
                                    onFilePicked: (f) {
                                      print(f?.name);
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Artists",
                          style: context.style.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 300,
                          child: SearchView(
                            artists: artists
                                .where((element) =>
                                    !state.track.artists.contains(element.id))
                                .toList(),
                            onSelected: notifier.toggleArtist,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: artists
                              .where((element) =>
                                  state.track.artists.contains(element.id))
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
                                    notifier.toggleArtist(e.id);
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
                          "Categories",
                          style: context.style.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 300,
                          child: SearchView(
                            categories: categories
                                .where((element) => !state.track.categories
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
                                  state.track.categories.contains(element.id))
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Moods",
                          style: context.style.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 300,
                          child: SearchView(
                            moods: moods
                                .where((element) =>
                                    !state.track.moods.contains(element.id))
                                .toList(),
                            onSelected: notifier.toggleMood,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: moods
                              .where((element) =>
                                  state.track.moods.contains(element.id))
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
                                    notifier.toggleMood(e.id);
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
                          "Track",
                          style: context.style.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        AudioUploadView(
                          file: state.file,
                          url: state.track.url.crim,
                          onFilePicked: notifier.fileChanged,
                          onClear: () => notifier.fileChanged(null),
                          duration: notifier.durationChanged,
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
                            controller: tagController,
                            decoration: const InputDecoration(
                              hintText: "Enter tag here",
                            ),
                            onFieldSubmitted: (value) {
                              notifier.toggleTag(value);
                              tagController.clear();
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: state.track.tags
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
                                        state.track.descriptionLang(lang),
                                    decoration: InputDecoration(
                                      hintText:
                                          "Description for ${Labels.lang(lang)}",
                                    ),
                                    onChanged: (value) {
                                      notifier.descriptionChanged(
                                          value.trim(), lang);
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
                          "Lyrics",
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
                                    initialValue: state.track.lyricsLang(lang),
                                    decoration: InputDecoration(
                                      hintText:
                                          "Lyrics for ${Labels.lang(lang)}",
                                    ),
                                    onChanged: (value) {
                                      notifier.lyricsChanged(value, lang);
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
                          Row(
                            children: [
                              Text(
                                "Reference Links",
                                style: context.style.titleSmall,
                              ),
                              IconButton(
                                onPressed: () async {
                                  String link = "|";
                                  final bool? value = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Add Link"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            initialValue: link.split('|').first,
                                            decoration: const InputDecoration(
                                              hintText: "Display Name",
                                            ),
                                            onChanged: (value) {
                                              link =
                                                  "$value|${link.split('|').last}";
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          TextFormField(
                                            initialValue: link.split('|').last,
                                            decoration: const InputDecoration(
                                              hintText: "URL",
                                            ),
                                            onChanged: (value) {
                                              link =
                                                  "${link.split('|').first}|$value";
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text("Add"),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (value == true) {
                                    if (link.split('|').first.isNotEmpty &&
                                        link.split('|').last.isNotEmpty) {
                                      notifier.linksChanged(
                                          [...state.track.links ?? [], link]);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          ...(state.track.links ?? []).map(
                            (e) => ListTile(
                              onTap: () {
                                launchUrlString(e.split('|').last);
                              },
                              title: Text(
                                e.split('|').first,
                                style:
                                    const TextStyle(color: Colors.blueAccent),
                              ),
                              subtitle: Text(e.split('|').last),
                              trailing: IconButton(
                                onPressed: () {
                                  notifier.linksChanged(state.track.links
                                          ?.where((element) => element != e)
                                          .toList() ??
                                      []);
                                },
                                icon: Icon(Icons.close_rounded),
                              ),
                            ),
                          )
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Group Id",
                                style: context.style.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: state.track.groupId,
                                items: groupIds
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (v) {
                                  notifier.groupIdChanged(v);
                                },
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      notifier.groupIdChanged(null);
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Group Index",
                                style: context.style.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                initialValue:
                                    state.track.groupIndex?.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  notifier
                                      .groupIndexChanged(int.tryParse(value));
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ],
                          ),
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
                      if (!state.track.active)
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
