// ignore_for_file: unused_result, use_build_context_synchronously

import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/components/image_upload_view.dart';
import 'package:avahan/admin/components/search_view.dart';
import 'package:avahan/admin/moods/providers/moods_notifier.dart';
import 'package:avahan/admin/notify/providers/notify_notifier.dart';
import 'package:avahan/admin/playlist/providers/playlists_notifier.dart';
import 'package:avahan/admin/profiles/providers/profile_provider.dart';
import 'package:avahan/admin/profiles/widgets/profiles_search_bar.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/enums/gender.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/enums/notify_frequency.dart';
import 'package:avahan/core/models/push_notification.dart';
import 'package:avahan/core/topics.dart';
import 'package:avahan/features/location/search_city_delegate.dart';
import 'package:avahan/features/location/search_country_delegate.dart';
import 'package:avahan/features/location/search_state_delegate.dart';
import 'package:avahan/utils/dates.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/labels.dart';
import 'package:avahan/utils/utils.dart';
import 'package:avahan/utils/validators.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

class NotifyPage extends HookConsumerWidget {
  NotifyPage({super.key, this.initial});

  final formKey = GlobalKey<FormState>();
  final PushNotification? initial;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final empty = PushNotification(
      title: "",
      body: "",
      createdAt: DateTime.now(),
      topic: Topics.all,
      timezone: 'Asia/Kolkata',
    );
    final createProvider = notifyNotifierProvider(initial);
    final state = ref.watch(createProvider);
    final notifier = ref.read(createProvider.notifier);

    final categories = ref
        .read(adminCategoriesNotifierProvider)
        .categories
        .where((element) => element.active)
        .toList();
    final tracks = ref
        .read(adminTracksNotifierProvider)
        .tracks
        .where((element) => element.active)
        .toList();
    final playlists = ref
        .read(adminPlaylistNotifierProvider)
        .playlists
        .where((element) => element.active)
        .toList();
    final moods = ref.read(adminMoodsNotifierProvider).moods;
    final artists = ref
        .read(adminArtistsNotifierProvider)
        .artists
        .where((element) => element.active)
        .toList();
    final detroit =
        tz.getLocation(state.notification.timezone ?? 'Asia/Kolkata');
    return Dialog(
      child: SizedBox(
        width: 800,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              key: ValueKey(createProvider.hashCode),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Title*',
                  style: context.style.titleSmall,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  initialValue: state.notification.title,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (v) => notifier.titleChanged(v.trim()),
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),
                Text(
                  'Body*',
                  style: context.style.titleSmall,
                ),
                const SizedBox(height: 4),
                TextFormField(
                  maxLines: 2,
                  initialValue: state.notification.body,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (v) => notifier.bodyChanged(v.trim()),
                  validator: Validators.required,
                ),
                const SizedBox(height: 16),
                Text(
                  'Image',
                  style: context.style.titleSmall,
                ),
                const SizedBox(height: 4),
                ImageUploadView(
                  onFilePicked: notifier.fileChanged,
                  url: state.notification.image,
                  file: state.xFile,
                  aspectRatio: 2,
                  onUrlChanged: notifier.imageChanged,
                ),
                const SizedBox(height: 16),
                Text(
                  'Redirect to',
                  style: context.style.titleSmall,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AvahanDataType.track,
                      AvahanDataType.artist,
                      AvahanDataType.category,
                      AvahanDataType.mood,
                      AvahanDataType.playlist,
                      AvahanDataType.unknown,
                    ]
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ChoiceChip(
                              label: Text(e == AvahanDataType.unknown
                                  ? "Link"
                                  : context.labels.labelsByAvahanDataType(e)),
                              selected: state.notification.type == e,
                              onSelected: (v) {
                                notifier.typeChanged(v ? e : null);
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
                if (state.notification.type != null &&
                    state.notification.type != AvahanDataType.unknown) ...[
                  Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: SearchView(
                          categories:
                              state.notification.type == AvahanDataType.category
                                  ? categories
                                  : [],
                          artists:
                              state.notification.type == AvahanDataType.artist
                                  ? artists
                                  : [],
                          moods: state.notification.type == AvahanDataType.mood
                              ? moods
                              : [],
                          tracks:
                              state.notification.type == AvahanDataType.track
                                  ? tracks
                                  : [],
                          playlists:
                              state.notification.type == AvahanDataType.playlist
                                  ? playlists
                                  : [],
                          onSelected: (id) {
                            notifier.idToggled(id);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  switch (state.notification.type) {
                    AvahanDataType.category => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories
                            .where((element) =>
                                state.notification.ids?.contains(element.id) ??
                                false)
                            .map(
                              (e) => Chip(
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: context.scheme.outline,
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                labelPadding: const EdgeInsets.all(8),
                                avatar: CircleAvatar(
                                  backgroundImage:
                                      CachedNetworkImageProvider(e.icon()),
                                ),
                                label: Text(e.name()),
                                onDeleted: () {
                                  notifier.idToggled(e.id);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    AvahanDataType.artist => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: artists
                            .where((element) =>
                                state.notification.ids?.contains(element.id) ??
                                false)
                            .map(
                              (e) => Chip(
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: context.scheme.outline,
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                labelPadding: const EdgeInsets.all(8),
                                avatar: CircleAvatar(
                                  backgroundImage:
                                      CachedNetworkImageProvider(e.icon()),
                                ),
                                label: Text(e.name()),
                                onDeleted: () {
                                  notifier.idToggled(e.id);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    AvahanDataType.mood => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: moods
                            .where((element) =>
                                state.notification.ids?.contains(element.id) ??
                                false)
                            .map(
                              (e) => Chip(
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: context.scheme.outline,
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                labelPadding: const EdgeInsets.all(8),
                                avatar: CircleAvatar(
                                  backgroundImage:
                                      CachedNetworkImageProvider(e.icon()),
                                ),
                                label: Text(e.name()),
                                onDeleted: () {
                                  notifier.idToggled(e.id);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    AvahanDataType.playlist => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: playlists
                            .where((element) =>
                                state.notification.ids?.contains(element.id) ??
                                false)
                            .map(
                              (e) => Chip(
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: context.scheme.outline,
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                labelPadding: const EdgeInsets.all(8),
                                avatar: CircleAvatar(
                                  backgroundImage:
                                      CachedNetworkImageProvider(e.icon()),
                                ),
                                label: Text(e.name()),
                                onDeleted: () {
                                  notifier.idToggled(e.id);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    AvahanDataType.track => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tracks
                            .where((element) =>
                                state.notification.ids?.contains(element.id) ??
                                false)
                            .map(
                              (e) => Chip(
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: context.scheme.outline,
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                labelPadding: const EdgeInsets.all(8),
                                avatar: CircleAvatar(
                                  backgroundImage:
                                      CachedNetworkImageProvider(e.icon()),
                                ),
                                label: Text(e.name()),
                                onDeleted: () {
                                  notifier.idToggled(e.id);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    _ => const SizedBox()
                  },
                ],
                if (state.notification.type == AvahanDataType.unknown) ...[
                  TextFormField(
                    initialValue: state.notification.link,
                    decoration: InputDecoration(
                      hintText: "e.g. https://example.com",
                    ),
                    onChanged: notifier.linkChanged,
                  ),
                ],
                const Divider(),
                Text(
                  'To',
                  style: context.style.titleMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: state.topic,
                      onChanged: (v) {
                        notifier.modeChanged(true);
                      },
                    ),
                    Text(
                      'Topic',
                      style: context.style.labelMedium,
                    ),
                    const SizedBox(width: 16),
                    Radio(
                      value: false,
                      groupValue: state.topic,
                      onChanged: (v) {
                        notifier.modeChanged(false);
                      },
                    ),
                    Text(
                      'Filter',
                      style: context.style.labelMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                state.topic
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            runSpacing: 8,
                            spacing: 8,
                            children: Topics.values
                                .map(
                                  (e) => ChoiceChip(
                                    label: Text(e),
                                    selected: state.notification.topic == e,
                                    onSelected: (v) {
                                      notifier.topicChanged(e);
                                    },
                                  ),
                                )
                                .toList(),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Channel',
                            style: context.style.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              TargetPlatform.android,
                              TargetPlatform.iOS,
                            ]
                                .map(
                                  (e) => ChoiceChip(
                                    label: Text(e.name.capLabel.split(' ').join()),
                                    selected: state.notification.channel == e.name,
                                    onSelected: (v) {
                                      notifier.channelChanged(
                                        state.notification.channel == e.name
                                            ? null
                                            : e.name,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Language',
                            style: context.style.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: Lang.values
                                .map(
                                  (e) => ChoiceChip(
                                    label: Text(Labels.lang(e)),
                                    selected: state.notification.lang == e,
                                    onSelected: (v) {
                                      notifier.langChanged(
                                          state.notification.lang == e
                                              ? null
                                              : e);
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Age',
                            style: context.style.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: Utils.ageRangeSet.map(
                              (e) {
                                final selected =
                                    state.notification.ageMin == e.min &&
                                        state.notification.ageMax == e.max;
                                return ChoiceChip(
                                  label: Text(
                                    Utils.labelByAgeRange(e),
                                  ),
                                  selected: selected,
                                  onSelected: (v) {
                                    notifier.ageMinMaxChanged(
                                        selected ? null : e.min,
                                        selected ? null : e.max);
                                  },
                                );
                              },
                            ).toList(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gender',
                            style: context.style.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Gender.male,
                              Gender.female,
                              Gender.nonBinary,
                              Gender.other,
                              Gender.preferNotToSay,
                            ].map(
                              (e) {
                                return ChoiceChip(
                                  label: Text(
                                      context.locale(Lang.en).labelByGender(e)),
                                  selected: state.notification.gender == e,
                                  onSelected: (v) {
                                    notifier.genderChanged(
                                        state.notification.gender == e
                                            ? null
                                            : e);
                                  },
                                );
                              },
                            ).toList(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Location',
                            style: context.style.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (state.notification.country != null)
                                Chip(
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: context.scheme.outline,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  label: Text(state.notification.country!.name),
                                  onDeleted: () {
                                    notifier.countryChanged(null);
                                  },
                                ),
                              if (state.notification.state != null)
                                Chip(
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: context.scheme.outline,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  label: Text(state.notification.state!.name),
                                  onDeleted: () {
                                    notifier.stateChanged(null);
                                  },
                                ),
                              if (state.notification.city != null)
                                Chip(
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: context.scheme.outline,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  label: Text(state.notification.city!),
                                  onDeleted: () {
                                    notifier.cityChanged(null);
                                  },
                                ),
                              if ([
                                state.notification.country,
                                state.notification.state,
                                state.notification.city,
                              ].contains(null))
                                IconButton(
                                  onPressed: () async {
                                    if (state.notification.country == null) {
                                      final country = await showSearch(
                                        context: context,
                                        delegate: SearchCountryDelegate(),
                                      );
                                      if (country != null) {
                                        notifier.countryChanged(country);
                                      }
                                    } else if (state.notification.state ==
                                        null) {
                                      final state_ = await showSearch(
                                        context: context,
                                        delegate: SearchStateDelegate(
                                            state.notification.country!.iso),
                                      );
                                      if (state_ != null) {
                                        notifier.stateChanged(state_);
                                      }
                                    } else if (state.notification.city ==
                                        null) {
                                      final city = await showSearch(
                                        context: context,
                                        delegate: SearchCityDelegate(
                                            state.notification.country!.iso,
                                            state.notification.state!.iso),
                                      );
                                      if (city != null) {
                                        notifier.cityChanged(city);
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.add_rounded),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Subscription',
                            style: context.style.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ChoiceChip(
                                label: const Text("Premium"),
                                selected: state.notification.premium == true,
                                onSelected: (v) {
                                  notifier.premiumChanged(
                                    (state.notification.premium == true)
                                        ? null
                                        : true,
                                  );
                                },
                              ),
                              ChoiceChip(
                                label: const Text("Free Tier"),
                                selected: state.notification.premium == false,
                                onSelected: (v) {
                                  notifier.premiumChanged(
                                    (state.notification.premium == false)
                                        ? null
                                        : false,
                                  );
                                },
                              ),
                              Container(
                                height: 32,
                                width: 2,
                                color: context.scheme.outlineVariant,
                              ),
                              ChoiceChip(
                                label: const Text("Active"),
                                selected: state.notification.expired == false,
                                onSelected: (v) {
                                  notifier.expiredChanged(
                                    (state.notification.expired == true)
                                        ? null
                                        : false,
                                  );
                                },
                              ),
                              ChoiceChip(
                                label: const Text("Expired"),
                                selected: state.notification.expired == true,
                                onSelected: (v) {
                                  notifier.expiredChanged(
                                    (state.notification.expired == true)
                                        ? null
                                        : true,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              // Checkbox(
                              //   value: state.profiles != null,
                              //   onChanged: (v) {
                              //     if (v ?? false) {
                              //       notifier.getUsers();
                              //     } else {
                              //       notifier.clearUsers();
                              //     }
                              //   },
                              // ),
                              // const SizedBox(width: 8),
                              Text(
                                'Specific listeners',
                                style: context.style.titleSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // if (state.profiles != null) ...[
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: ProfileSearchView(
                                  alreadySelected:
                                      state.notification.users ?? [],
                                  onSelected: (id) {
                                    notifier.usersAdd(id);
                                  },
                                  notification: state.notification,
                                ),
                              ),
                              TextButton.icon(
                                icon: Icon(Icons.add_rounded),
                                onPressed: () {
                                  notifier.usersAdd([25]);
                                },
                                label: Text('Test listeners'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (state.notification.users ?? [])
                                .map(
                                  (e) => HookConsumer(
                                    builder: (context, ref, child) {
                                      return ref
                                          .watch(adminProfileProvider(e))
                                          .when(
                                            data: (profile) => Chip(
                                              shape: StadiumBorder(
                                                side: BorderSide(
                                                  color: context.scheme.outline,
                                                ),
                                              ),

                                              padding: const EdgeInsets.all(8),
                                              // labelPadding: const EdgeInsets.all(8),
                                              label:
                                                  Text('#$e ${profile.name}'),
                                              onDeleted: () {
                                                notifier.userToggle(profile.id);
                                              },
                                            ),
                                            error: (e, s) {
                                              return const SizedBox();
                                            },
                                            loading: () {
                                              return const SizedBox();
                                            },
                                          );
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                          // ],
                        ],
                      ),
                const Divider(),
                Text(
                  'Schedule',
                  style: context.style.titleMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Frequency',
                  style: context.style.titleSmall,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: NotifyFrequency.values.map(
                    (e) {
                      return ChoiceChip(
                        label: Text(
                            context.locale(Lang.en).labelsByNotifyFrequency(e)),
                        selected: state.notification.frequency == e,
                        onSelected: (v) {
                          notifier.frequencyChanged(
                              state.notification.frequency == e ? null : e);
                        },
                      );
                    },
                  ).toList(),
                ),
                if (state.notification.frequency != null) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: [
                      if (state.notification.frequency == NotifyFrequency.once)
                        SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date',
                                style: context.style.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                  text: state.notification.date?.dateLabel3,
                                ),
                                onTap: () async {
                                  final d = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        state.notification.date ?? Dates.today,
                                    firstDate: Dates.today,
                                    lastDate: Dates.today.add(
                                      const Duration(days: 30),
                                    ),
                                  );
                                  if (d != null) {
                                    notifier.dateChanged(d);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      if (state.notification.frequency ==
                          NotifyFrequency.monthly)
                        SizedBox(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Day',
                                style: context.style.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<int?>(
                                items: List.generate(31, (index) => index + 1)
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text("$e"),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  notifier.dayChanged(v);
                                },
                              ),
                            ],
                          ),
                        ),
                      if (state.notification.frequency ==
                          NotifyFrequency.weekly)
                        SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Weekday',
                                style: context.style.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              DropdownButtonFormField(
                                items: Dates.weekdays
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  notifier.weekdayChanged(v);
                                },
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: context.style.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField(
                                    value: state.notification.time != null
                                        ? Dates.today.copyWith(
                                            hour: state.notification.time
                                                ?.fromTimezone(
                                                    state.notification.timezone)
                                                .hour,
                                            minute: state.notification.time
                                                ?.forTimezone(
                                                    state.notification.timezone)
                                                .minute,
                                          )
                                        : null,
                                    items: List.generate(
                                      96,
                                      (index) => Dates.today.add(
                                        Duration(minutes: 15 * index),
                                      ),
                                    )
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e.timeLabel),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        notifier.timeChanged(
                                          v.forTimezone(
                                              state.notification.timezone),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: DropdownButtonFormField(
                                    value: state.notification.timezone,
                                    isExpanded: true,
                                    items: tz.timeZoneDatabase.locations.entries
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.key,
                                            child: Text(
                                              e.key,
                                              style: context.style.bodySmall,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      notifier
                                          .timezoneChanged(v ?? 'Asia/Kolkata');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                Text(state.validatorMessage ?? ""),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 24)),
                    onPressed: state.loading || !state.enabled
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                await notifier.create(false);
                                if (state.notification.frequency != null) {
                                  Navigator.pop(context, false);
                                } else {
                                  Navigator.pop(context, true);
                                }
                              } catch (e) {
                                context.error(e);
                              }
                            }
                          },
                    child: const Text("Send"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: false,
    //     title: const Text('Notify'),
    //   ),
    //   body: Row(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: [
    //       Expanded(
    //         child:
    //       ),
    //       Container(
    //         width: 4,
    //         color: context.scheme.surfaceTint.withOpacity(0.05),
    //       ),
    //       Expanded(
    //         child: NotificationsView(
    //           onDublicate: (v) {
    //             initial.value = v.copyWith(id: 0);
    //           },
    //           onEdit: (v) {
    //             initial.value = v;
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
