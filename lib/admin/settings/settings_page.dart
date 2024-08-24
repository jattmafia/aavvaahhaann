// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/components/search_view.dart';
import 'package:avahan/admin/components/table_wrapper.dart';
import 'package:avahan/admin/moods/providers/moods_notifier.dart';
import 'package:avahan/admin/playlist/providers/playlists_notifier.dart';
import 'package:avahan/admin/settings/providers/banner_stats_provider.dart';
import 'package:avahan/admin/settings/providers/settings_notifier.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/core/enums/avahan_data_type.dart';
import 'package:avahan/core/models/app_banner.dart';
import 'package:avahan/core/models/datetime_slot.dart';
import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/components/loading_layer.dart';
import 'package:avahan/utils/dates.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AdminSettingsPage extends HookConsumerWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref
        .watch(adminCategoriesNotifierProvider)
        .categories
        .where((element) => element.active)
        .toList();
    final tracks = ref
        .watch(adminTracksNotifierProvider)
        .tracks
        .where((element) => element.active)
        .toList();
    final playlists = ref
        .watch(adminPlaylistNotifierProvider)
        .playlists
        .where((element) => element.active)
        .toList();
    final moods = ref.read(adminMoodsNotifierProvider).moods;
    final artists = ref
        .watch(adminArtistsNotifierProvider)
        .artists
        .where((element) => element.active)
        .toList();

    final groupIdController = useTextEditingController();

    final tabController = useTabController(initialLength: 3);

    Future<DateTimeSlot?> pickDateTimeSlot() async {
      final startDate = await showDatePicker(
        context: context,
        helpText: "Start date",
        firstDate: Dates.today,
        lastDate: Dates.today.add(
          const Duration(days: 365),
        ),
      );
      if (startDate != null) {
        final startTime = await showTimePicker(
          context: context,
          helpText: 'Start time',
          initialTime: const TimeOfDay(hour: 0, minute: 0),
        );
        if (startTime != null) {
          final endDate = await showDatePicker(
            context: context,
            firstDate: startDate,
            helpText: "End date",
            lastDate: startDate.add(
              const Duration(days: 365),
            ),
          );
          if (endDate != null) {
            final endTime = await showTimePicker(
              context: context,
              helpText: 'End time',
              initialTime: const TimeOfDay(hour: 0, minute: 0),
            );

            if (endTime != null) {
              final startDateTime = DateTime(
                startDate.year,
                startDate.month,
                startDate.day,
                startTime.hour,
                startTime.minute,
              );
              final endDateTime = DateTime(
                endDate.year,
                endDate.month,
                endDate.day,
                endTime.hour,
                endTime.minute,
              );
              return DateTimeSlot(
                start: startDateTime,
                end: endDateTime,
              );
            }
          }
        }
      }
      return null;
    }

    return AsyncWidget(
      value: ref.watch(masterDataProvider),
      data: (data) {
        final provider = adminSettingsNotifierProvider(data);
        final state = ref.watch(provider);
        final notifier = ref.read(provider.notifier);

        return HookConsumer(builder: (context, ref, child) {
          final list = useRef<List<String>>(
            data.banners
                .map((e) => e.id)
                .where((e) => e != null)
                .toList()
                .cast(),
          );

          final bannerStats = ref
                  .watch(
                    bannerStatsProvider(list.value),
                  )
                  .asData
                  ?.value ??
              {};

          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: const Text('Settings'),
              actions: [
                FilledButton(
                  onPressed: notifier.savable
                      ? () async {
                          try {
                            await notifier.save();
                          } catch (e) {
                            context.error(e);
                          }
                        }
                      : null,
                  child: const Text("Save"),
                ),
                const SizedBox(width: 16),
              ],
            ),
            body: LoadingLayer(
              loading: state.loading,
              child: Column(
                children: [
                  TabBar(
                    controller: tabController,
                    tabs: [
                      const Tab(
                        text: "Banners",
                      ),
                      const Tab(
                        text: "Free Trial",
                      ),
                      const Tab(
                        text: "Other",
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (
                                  label: "Active Banners",
                                  banners: state.masterData.banners
                                      .where((element) => element.active),
                                  change: notifier.bannersChanged,
                                  active: true,
                                ),
                                (
                                  label: "Inactive Banners",
                                  banners: state.masterData.banners
                                      .where((element) => !element.active),
                                  change: notifier.bannersChanged,
                                  active: false,
                                ),
                              ].map((t) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            t.label,
                                            style: context.style.titleMedium,
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              try {
                                                final picked =
                                                    await ImagePicker()
                                                        .pickImage(
                                                  source: ImageSource.gallery,
                                                );
                                                if (picked != null) {
                                                  t.change(
                                                    [
                                                      ...state
                                                          .masterData.banners,
                                                      AppBanner(
                                                        image: "",
                                                        file: picked,
                                                        active: t.active,
                                                      ),
                                                    ],
                                                  );
                                                }
                                              } catch (e) {
                                                print(e);
                                              }
                                            },
                                            icon: const Icon(Icons.add_rounded),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Column(
                                        children: t.banners.map(
                                          (b) {
                                            Widget buildBanner(
                                                String image,
                                                XFile? file,
                                                ValueChanged<XFile?>
                                                    onChanged) {
                                              return SizedBox(
                                                width: 400,
                                                child: HookConsumer(builder:
                                                    (context, ref, child) {
                                                  final memorised = useMemoized(
                                                    () => file?.readAsBytes(),
                                                    [file?.name],
                                                  );
                                                  final bytes =
                                                      useFuture(memorised);
                                                  return AspectRatio(
                                                    aspectRatio: 3,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        try {
                                                          final picked =
                                                              await ImagePicker()
                                                                  .pickImage(
                                                            source: ImageSource
                                                                .gallery,
                                                          );
                                                          if (picked != null) {
                                                            onChanged(picked);
                                                          }
                                                        } catch (e) {
                                                          print(e);
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: context
                                                                .scheme
                                                                .outlineVariant,
                                                          ),
                                                          color: context.scheme
                                                              .surfaceVariant,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          image: file != null
                                                              ? (kIsWeb
                                                                  ? (bytes.data !=
                                                                          null
                                                                      ? DecorationImage(
                                                                          image:
                                                                              MemoryImage(bytes.data!),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )
                                                                      : null)
                                                                  : DecorationImage(
                                                                      image:
                                                                          FileImage(
                                                                        File(file
                                                                            .path),
                                                                      ),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ))
                                                              : image.isNotEmpty
                                                                  ? DecorationImage(
                                                                      image: NetworkImage(
                                                                          image),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : null,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              );
                                            }

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          buildBanner(
                                                              b.image, b.file,
                                                              (value) {
                                                            t.change(
                                                              state.masterData
                                                                  .banners
                                                                  .map((e) {
                                                                if (e == b) {
                                                                  return b
                                                                      .copyWith(
                                                                    file: value,
                                                                  );
                                                                }
                                                                return e;
                                                              }).toList(),
                                                            );
                                                          }),
                                                          Positioned(
                                                            right: 0,
                                                            child: IconButton(
                                                              color: context
                                                                  .scheme.error,
                                                              onPressed: () {
                                                                t.change(
                                                                  state
                                                                      .masterData
                                                                      .banners
                                                                      .where(
                                                                          (e) =>
                                                                              e !=
                                                                              b)
                                                                      .toList(),
                                                                );
                                                              },
                                                              icon: const Icon(
                                                                Icons.delete,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      b.imageHi != null
                                                          ? Stack(
                                                              children: [
                                                                buildBanner(
                                                                    b.imageHi!,
                                                                    b.fileHi,
                                                                    (value) {
                                                                  t.change(
                                                                    state
                                                                        .masterData
                                                                        .banners
                                                                        .map(
                                                                            (e) {
                                                                      if (e ==
                                                                          b) {
                                                                        return b
                                                                            .copyWith(
                                                                          fileHi:
                                                                              value,
                                                                        );
                                                                      }
                                                                      return e;
                                                                    }).toList(),
                                                                  );
                                                                }),
                                                                Positioned(
                                                                  left: 0,
                                                                  child:
                                                                      Material(
                                                                    shape:
                                                                        const StadiumBorder(),
                                                                    color: context
                                                                        .scheme
                                                                        .primary
                                                                        .withOpacity(
                                                                            0.5),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8,
                                                                          vertical:
                                                                              2),
                                                                      child:
                                                                          Text(
                                                                        'Hindi',
                                                                        style: context
                                                                            .style
                                                                            .bodySmall
                                                                            ?.copyWith(
                                                                          color: context
                                                                              .scheme
                                                                              .onPrimary,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  right: 0,
                                                                  child:
                                                                      IconButton(
                                                                    color: context
                                                                        .scheme
                                                                        .error,
                                                                    onPressed:
                                                                        () {
                                                                      t.change(
                                                                        state
                                                                            .masterData
                                                                            .banners
                                                                            .map((e) {
                                                                          if (e ==
                                                                              b) {
                                                                            return b.copyWith(
                                                                              clearImageHi: true,
                                                                            );
                                                                          }
                                                                          return e;
                                                                        }).toList(),
                                                                      );
                                                                    },
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .clear_rounded,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : OutlinedButton.icon(
                                                              onPressed: () {
                                                                t.change(
                                                                  state
                                                                      .masterData
                                                                      .banners
                                                                      .map((e) {
                                                                    if (e ==
                                                                        b) {
                                                                      return b
                                                                          .copyWith(
                                                                        imageHi:
                                                                            "",
                                                                      );
                                                                    }
                                                                    return e;
                                                                  }).toList(),
                                                                );
                                                              },
                                                              icon: Icon(Icons
                                                                  .add_rounded),
                                                              label: Text(
                                                                  'Hindi Image'),
                                                            ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Visibility',
                                                                    style: context
                                                                        .style
                                                                        .titleSmall,
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),
                                                                  Row(
                                                                    children: [
                                                                      Switch(
                                                                        value: b
                                                                            .active,
                                                                        onChanged:
                                                                            (v) {
                                                                          t.change(
                                                                            state.masterData.banners.map((e) {
                                                                              if (e == b) {
                                                                                return b.copyWith(
                                                                                  active: v,
                                                                                );
                                                                              }
                                                                              return e;
                                                                            }).toList(),
                                                                          );
                                                                        },
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              8),
                                                                      b.dateTimeSlot ==
                                                                              null
                                                                          ? TextButton(
                                                                              onPressed: () async {
                                                                                final slot = await pickDateTimeSlot();
                                                                                if (slot != null) {
                                                                                  t.change(
                                                                                    state.masterData.banners.map((e) {
                                                                                      if (e == b) {
                                                                                        return b.copyWith(
                                                                                          dateTimeSlot: slot,
                                                                                        );
                                                                                      }
                                                                                      return e;
                                                                                    }).toList(),
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: const Text("Set Timeframe"),
                                                                            )
                                                                          : DateTimeSlotTile(
                                                                              slot: b.dateTimeSlot!,
                                                                              onRemove: () {
                                                                                t.change(
                                                                                  state.masterData.banners.map((e) {
                                                                                    if (e == b) {
                                                                                      return b.copyWith(
                                                                                        clearDateTimeSlot: true,
                                                                                      );
                                                                                    }
                                                                                    return e;
                                                                                  }).toList(),
                                                                                );
                                                                              },
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            if (bannerStats[
                                                                    b.id] !=
                                                                null) ...[
                                                              const SizedBox(
                                                                  width: 16),
                                                              Builder(builder:
                                                                  (context) {
                                                                final bns =
                                                                    bannerStats[
                                                                        b.id]!;
                                                                return Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    const Text('Clicks'),
                                                                    const SizedBox(height: 8),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            Text(
                                                                              "Today",
                                                                              style: context
                                                                                  .style
                                                                                  .bodySmall
                                                                                  ?.copyWith(color: context.scheme.outline),
                                                                            ),
                                                                            Text(
                                                                              "${bns.today}",
                                                                              style: context
                                                                                  .style
                                                                                  .titleSmall,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                8),
                                                                        Column(
                                                                          children: [
                                                                            Text(
                                                                              "Last 7 days",
                                                                                style: context
                                                                                  .style
                                                                                  .bodySmall
                                                                                  ?.copyWith(color: context.scheme.outline),
                                                                            ),
                                                                            Text(
                                                                              "${bns.last7Days}",
                                                                              style: context
                                                                                  .style
                                                                                  .titleSmall,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                8),
                                                                        Column(
                                                                          children: [
                                                                            Text(
                                                                              "Last 30 days",
                                                                              style: context
                                                                                  .style
                                                                                  .bodySmall?.copyWith(
                                                                                    color: context.scheme.outline
                                                                                  ),
                                                                            ),
                                                                            Text(
                                                                              "${bns.last30Days}",
                                                                              style: context
                                                                                  .style
                                                                                  .titleSmall,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                8),
                                                                        Column(
                                                                          children: [
                                                                            Text(
                                                                              "This Month",
                                                                                style: context
                                                                                  .style
                                                                                  .bodySmall
                                                                                  ?.copyWith(color: context.scheme.outline),
                                                                            ),
                                                                            Text(
                                                                              "${bns.thisMonth}",
                                                                              style: context
                                                                                  .style
                                                                                  .titleSmall,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                );
                                                              }),
                                                            ],
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          'Redirect to',
                                                          style: context
                                                              .style.titleSmall,
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children: [
                                                              AvahanDataType
                                                                  .track,
                                                              AvahanDataType
                                                                  .artist,
                                                              AvahanDataType
                                                                  .category,
                                                              AvahanDataType
                                                                  .mood,
                                                              AvahanDataType
                                                                  .playlist,
                                                              const MapEntry(
                                                                "link",
                                                                "Link",
                                                              ),
                                                              const MapEntry(
                                                                "premium",
                                                                "Premium",
                                                              ),
                                                            ]
                                                                .map(
                                                                  (type) =>
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            12),
                                                                    child:
                                                                        ChoiceChip(
                                                                      label: Text(type
                                                                              is AvahanDataType
                                                                          ? context
                                                                              .labels
                                                                              .labelsByAvahanDataType(type)
                                                                          : type is MapEntry<String, String>
                                                                              ? type.value
                                                                              : ""),
                                                                      selected: b
                                                                              .action ==
                                                                          (type is AvahanDataType
                                                                              ? type.name
                                                                              : type is MapEntry<String, String>
                                                                                  ? type.key
                                                                                  : ""),
                                                                      onSelected:
                                                                          (v) {
                                                                        t.change(
                                                                          state
                                                                              .masterData
                                                                              .banners
                                                                              .map(
                                                                            (e) {
                                                                              if (e == b) {
                                                                                return b.copyWith(
                                                                                  action: (type is AvahanDataType
                                                                                      ? type.name
                                                                                      : type is MapEntry<String, String>
                                                                                          ? type.key
                                                                                          : ""),
                                                                                );
                                                                              }
                                                                              return e;
                                                                            },
                                                                          ).toList(),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                )
                                                                .toList(),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        if (b.action !=
                                                            null) ...[
                                                          if (AvahanDataType
                                                              .values
                                                              .map(
                                                                  (e) => e.name)
                                                              .contains(b
                                                                  .action)) ...[
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 300,
                                                                  child:
                                                                      SearchView(
                                                                    categories: b.action ==
                                                                            AvahanDataType.category.name
                                                                        ? categories
                                                                        : [],
                                                                    artists: b.action ==
                                                                            AvahanDataType.artist.name
                                                                        ? artists
                                                                        : [],
                                                                    moods: b.action ==
                                                                            AvahanDataType.mood.name
                                                                        ? moods
                                                                        : [],
                                                                    tracks: b.action ==
                                                                            AvahanDataType.track.name
                                                                        ? tracks
                                                                        : [],
                                                                    playlists: b.action ==
                                                                            AvahanDataType.playlist.name
                                                                        ? playlists
                                                                        : [],
                                                                    onSelected:
                                                                        (id) {
                                                                      t.change(
                                                                        state
                                                                            .masterData
                                                                            .banners
                                                                            .map((e) {
                                                                          if (e ==
                                                                              b) {
                                                                            return b.copyWith(
                                                                              ids: b.ids?.contains(id) == true
                                                                                  ? null
                                                                                  : {
                                                                                      ...(b.ids ?? <int>[]),
                                                                                      id
                                                                                    }.toList(),
                                                                            );
                                                                          }
                                                                          return e;
                                                                        }).toList(),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                          ],
                                                          switch (b.action) {
                                                            "category" => Wrap(
                                                                spacing: 8,
                                                                runSpacing: 8,
                                                                children:
                                                                    categories
                                                                        .where((element) =>
                                                                            b.ids?.contains(element.id) ??
                                                                            false)
                                                                        .map(
                                                                          (e) =>
                                                                              Chip(
                                                                            shape:
                                                                                StadiumBorder(
                                                                              side: BorderSide(
                                                                                color: context.scheme.outline,
                                                                              ),
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.all(8),
                                                                            labelPadding:
                                                                                const EdgeInsets.all(8),
                                                                            avatar:
                                                                                CircleAvatar(
                                                                              backgroundImage: CachedNetworkImageProvider(e.icon()),
                                                                            ),
                                                                            label:
                                                                                Text(e.name()),
                                                                            onDeleted:
                                                                                () {
                                                                              t.change(
                                                                                state.masterData.banners.map((banner) {
                                                                                  if (banner == b) {
                                                                                    return b.copyWith(
                                                                                      ids: b.ids?.where((element) => element != e.id).toList(),
                                                                                    );
                                                                                  }
                                                                                  return banner;
                                                                                }).toList(),
                                                                              );
                                                                            },
                                                                          ),
                                                                        )
                                                                        .toList(),
                                                              ),
                                                            "artist" => Wrap(
                                                                spacing: 8,
                                                                runSpacing: 8,
                                                                children:
                                                                    artists
                                                                        .where((element) =>
                                                                            b.ids?.contains(element.id) ??
                                                                            false)
                                                                        .map(
                                                                          (e) =>
                                                                              Chip(
                                                                            shape:
                                                                                StadiumBorder(
                                                                              side: BorderSide(
                                                                                color: context.scheme.outline,
                                                                              ),
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.all(8),
                                                                            labelPadding:
                                                                                const EdgeInsets.all(8),
                                                                            avatar:
                                                                                CircleAvatar(
                                                                              backgroundImage: CachedNetworkImageProvider(e.icon()),
                                                                            ),
                                                                            label:
                                                                                Text(e.name()),
                                                                            onDeleted:
                                                                                () {
                                                                              t.change(
                                                                                state.masterData.banners.map((banner) {
                                                                                  if (banner == b) {
                                                                                    return b.copyWith(
                                                                                      ids: b.ids?.where((element) => element != e.id).toList(),
                                                                                    );
                                                                                  }
                                                                                  return banner;
                                                                                }).toList(),
                                                                              );
                                                                            },
                                                                          ),
                                                                        )
                                                                        .toList(),
                                                              ),
                                                            "mood" => Wrap(
                                                                spacing: 8,
                                                                runSpacing: 8,
                                                                children: moods
                                                                    .where((element) =>
                                                                        b.ids?.contains(
                                                                            element.id) ??
                                                                        false)
                                                                    .map(
                                                                      (e) =>
                                                                          Chip(
                                                                        shape:
                                                                            StadiumBorder(
                                                                          side:
                                                                              BorderSide(
                                                                            color:
                                                                                context.scheme.outline,
                                                                          ),
                                                                        ),
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                        labelPadding: const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                        avatar:
                                                                            CircleAvatar(
                                                                          backgroundImage:
                                                                              CachedNetworkImageProvider(e.icon()),
                                                                        ),
                                                                        label: Text(
                                                                            e.name()),
                                                                        onDeleted:
                                                                            () {
                                                                          t.change(
                                                                            state.masterData.banners.map((banner) {
                                                                              if (banner == b) {
                                                                                return b.copyWith(
                                                                                  ids: b.ids?.where((element) => element != e.id).toList(),
                                                                                );
                                                                              }
                                                                              return banner;
                                                                            }).toList(),
                                                                          );
                                                                        },
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                              ),
                                                            "playlist" => Wrap(
                                                                spacing: 8,
                                                                runSpacing: 8,
                                                                children:
                                                                    playlists
                                                                        .where((element) =>
                                                                            b.ids?.contains(element.id) ??
                                                                            false)
                                                                        .map(
                                                                          (e) =>
                                                                              Chip(
                                                                            shape:
                                                                                StadiumBorder(
                                                                              side: BorderSide(
                                                                                color: context.scheme.outline,
                                                                              ),
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.all(8),
                                                                            labelPadding:
                                                                                const EdgeInsets.all(8),
                                                                            avatar:
                                                                                CircleAvatar(
                                                                              backgroundImage: CachedNetworkImageProvider(e.icon()),
                                                                            ),
                                                                            label:
                                                                                Text(e.name()),
                                                                            onDeleted:
                                                                                () {
                                                                              t.change(
                                                                                state.masterData.banners.map((banner) {
                                                                                  if (banner == b) {
                                                                                    return b.copyWith(
                                                                                      ids: b.ids?.where((element) => element != e.id).toList(),
                                                                                    );
                                                                                  }
                                                                                  return banner;
                                                                                }).toList(),
                                                                              );
                                                                            },
                                                                          ),
                                                                        )
                                                                        .toList(),
                                                              ),
                                                            "track" => Wrap(
                                                                spacing: 8,
                                                                runSpacing: 8,
                                                                children: tracks
                                                                    .where((element) =>
                                                                        b.ids?.contains(
                                                                            element.id) ??
                                                                        false)
                                                                    .map(
                                                                      (e) =>
                                                                          Chip(
                                                                        shape:
                                                                            StadiumBorder(
                                                                          side:
                                                                              BorderSide(
                                                                            color:
                                                                                context.scheme.outline,
                                                                          ),
                                                                        ),
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                        labelPadding: const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                        avatar:
                                                                            CircleAvatar(
                                                                          backgroundImage:
                                                                              CachedNetworkImageProvider(e.icon()),
                                                                        ),
                                                                        label: Text(
                                                                            e.name()),
                                                                        onDeleted:
                                                                            () {
                                                                          t.change(
                                                                            state.masterData.banners.map((banner) {
                                                                              if (banner == b) {
                                                                                return b.copyWith(
                                                                                  ids: b.ids?.where((element) => element != e.id).toList(),
                                                                                );
                                                                              }
                                                                              return banner;
                                                                            }).toList(),
                                                                          );
                                                                        },
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                              ),
                                                            "link" =>
                                                              TextFormField(
                                                                initialValue:
                                                                    b.link,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  hintText:
                                                                      "https://example.com",
                                                                ),
                                                                onChanged: (v) {
                                                                  t.change(
                                                                    state
                                                                        .masterData
                                                                        .banners
                                                                        .map(
                                                                            (e) {
                                                                      if (e ==
                                                                          b) {
                                                                        return b
                                                                            .copyWith(
                                                                          link:
                                                                              v,
                                                                        );
                                                                      }
                                                                      return e;
                                                                    }).toList(),
                                                                  );
                                                                },
                                                              ),
                                                            _ =>
                                                              const SizedBox(),
                                                          },
                                                        ],
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Free Trial',
                                      style: context.style.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text('Days'),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        initialValue:
                                            "${notifier.masterData.freeTrailDays}",
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: const InputDecoration(
                                            hintText: "0"),
                                        onChanged: (v) {
                                          notifier.freeTrailDaysChanged(
                                              int.tryParse(v) ?? 0);
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Text('Free Tracks: '),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${state.masterData.freeTrialTracks.length}",
                                          style: context.style.titleSmall,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 300,
                                      child: SearchView(
                                        tracks: tracks
                                            .where((element) => !state
                                                .masterData.freeTrialTracks
                                                .contains(element.id))
                                            .toList(),
                                        onSelected: (id) {
                                          notifier.toggleFreeTrailTrack(id);
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        ...tracks
                                            .where(
                                              (element) => state
                                                  .masterData.freeTrialTracks
                                                  .contains(element.id),
                                            )
                                            .map(
                                              (e) => Chip(
                                                shape: StadiumBorder(
                                                  side: BorderSide(
                                                    color:
                                                        context.scheme.outline,
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                labelPadding:
                                                    const EdgeInsets.all(8),
                                                avatar: CircleAvatar(
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          e.icon()),
                                                ),
                                                label: Text(e.name()),
                                                onDeleted: () {
                                                  notifier.toggleFreeTrailTrack(
                                                      e.id);
                                                },
                                              ),
                                            )
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    const Text('Free slots'),
                                    const SizedBox(height: 8),
                                    TextButton.icon(
                                      onPressed: () async {
                                        final slot = await pickDateTimeSlot();
                                        if (slot != null) {
                                          notifier.toggleDateTimeSlot(slot);
                                        }
                                      },
                                      icon: const Icon(Icons.add_rounded),
                                      label: const Text('Add slot'),
                                    ),
                                    Column(
                                      children: state.masterData.freeSlots
                                          .map(
                                            (e) => DateTimeSlotTile(
                                              slot: e,
                                              onRemove: () {
                                                notifier.toggleDateTimeSlot(e);
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Group Ids",
                                      style: context.style.titleSmall,
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 300,
                                      child: TextFormField(
                                        controller: groupIdController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r"[a-z]"),
                                          ),
                                        ],
                                        decoration: const InputDecoration(
                                          hintText: "Enter name here",
                                        ),
                                        onFieldSubmitted: (value) {
                                          notifier.toggleGroupId(value);
                                          groupIdController.clear();
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: state.masterData.groupIds
                                          .map(
                                            (e) => Chip(
                                              shape: StadiumBorder(
                                                side: BorderSide(
                                                  color: context.scheme.outline,
                                                ),
                                              ),
                                              label: Text(e),
                                              onDeleted: () {
                                                notifier.toggleGroupId(e);
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 8,
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 300,
                                      child: TextFormField(
                                        maxLines: 4,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        initialValue:
                                            state.masterData.appShareMessage,
                                        decoration: const InputDecoration(
                                          labelText: "App share message",
                                        ),
                                        onChanged:
                                            notifier.appShareMessageChanged,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: TextFormField(
                                        initialValue:
                                            state.masterData.contactPhone,
                                        decoration: const InputDecoration(
                                          labelText: "Contact whatsapp number",
                                        ),
                                        onChanged: notifier.contactPhoneChanged,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: TextFormField(
                                        initialValue:
                                            state.masterData.contactEmail,
                                        decoration: const InputDecoration(
                                          labelText: "Contact email",
                                        ),
                                        onChanged: notifier.contactEmailChanged,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 600,
                                      child: TextFormField(
                                        initialValue: state.masterData.termsUrl,
                                        decoration: const InputDecoration(
                                          labelText: "Terms and conditions url",
                                        ),
                                        onChanged: notifier.termsUrlChanged,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 600,
                                      child: TextFormField(
                                        initialValue:
                                            state.masterData.privacyUrl,
                                        decoration: const InputDecoration(
                                          labelText: "Privacy policy url",
                                        ),
                                        onChanged: notifier.privacyUrlChanged,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 600,
                                      child: TextFormField(
                                        initialValue:
                                            state.masterData.aboutEnUrl,
                                        decoration: const InputDecoration(
                                          labelText: "About us url (English)",
                                        ),
                                        onChanged: notifier.aboutEnUrlChanged,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 600,
                                      child: TextFormField(
                                        initialValue:
                                            state.masterData.aboutHiUrl,
                                        decoration: const InputDecoration(
                                          labelText: "About us url (Hindi)",
                                        ),
                                        onChanged: notifier.aboutHiUrlChanged,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Versions',
                                        style: context.style.titleMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      TableWrapper(
                                        child: DataTable(
                                          columns: const [
                                            DataColumn(
                                              label: Text("Platform"),
                                            ),
                                            DataColumn(
                                              label: Text("Version Code"),
                                            ),
                                            DataColumn(
                                              label: Text("Force Update"),
                                            ),
                                          ],
                                          rows: [
                                            DataRow(
                                              cells: [
                                                const DataCell(
                                                  Text("Android"),
                                                ),
                                                DataCell(
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          notifier.versionChanged(
                                                              state.masterData
                                                                      .version -
                                                                  1);
                                                        },
                                                        icon: const Icon(Icons
                                                            .remove_rounded),
                                                      ),
                                                      Text(
                                                          "${state.masterData.version}"),
                                                      IconButton(
                                                        onPressed: () {
                                                          notifier.versionChanged(
                                                              state.masterData
                                                                      .version +
                                                                  1);
                                                        },
                                                        icon: const Icon(
                                                            Icons.add_rounded),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                DataCell(
                                                  Checkbox(
                                                    value:
                                                        state.masterData.force,
                                                    onChanged: (v) {
                                                      notifier.forceChanged(
                                                          v ?? false);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            DataRow(
                                              cells: [
                                                const DataCell(
                                                  Text("iOS"),
                                                ),
                                                DataCell(
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          notifier.versionIosChanged(
                                                              state.masterData
                                                                      .versionIos -
                                                                  1);
                                                        },
                                                        icon: const Icon(Icons
                                                            .remove_rounded),
                                                      ),
                                                      Text(
                                                          "${state.masterData.versionIos}"),
                                                      IconButton(
                                                        onPressed: () {
                                                          notifier.versionIosChanged(
                                                              state.masterData
                                                                      .versionIos +
                                                                  1);
                                                        },
                                                        icon: const Icon(
                                                            Icons.add_rounded),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                DataCell(
                                                  Checkbox(
                                                    value: state
                                                        .masterData.forceIos,
                                                    onChanged: (v) {
                                                      notifier.forceIosChanged(
                                                          v ?? false);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            'Maintenance Mode',
                                            style: context.style.titleMedium,
                                          ),
                                          const SizedBox(width: 28),
                                          Switch(
                                            value: state.masterData.maintenance,
                                            onChanged:
                                                notifier.maintenanceChanged,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
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
