// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/admin/categories/providers/categories_notifier.dart';
import 'package:avahan/admin/components/date_range_chips_view.dart';
import 'package:avahan/admin/components/table_wrapper.dart';
import 'package:avahan/admin/extensions.dart';
import 'package:avahan/admin/moods/providers/moods_notifier.dart';
import 'package:avahan/admin/playlist/providers/playlists_notifier.dart';
import 'package:avahan/admin/profiles/providers/library_items_provider.dart';
import 'package:avahan/admin/profiles/providers/play_sessions_analytics_of_user_provider.dart';
import 'package:avahan/admin/profiles/providers/profiles_notifier.dart';
import 'package:avahan/admin/profiles/providers/userplay_provider.dart';
import 'package:avahan/admin/tracks/providers/tracks_notifier.dart';
import 'package:avahan/core/enums/library_item_type.dart';
import 'package:avahan/core/models/profile.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:avahan/core/repositories/userplay_repository.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/notifications/providers/notifications_provider.dart';
import 'package:avahan/features/profile/providers/profile_provider.dart';
import 'package:avahan/utils/dates.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminProfilePage extends HookConsumerWidget {
  const AdminProfilePage({super.key, required this.profile});

  final Profile profile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    final profile =
        ref.watch(adminProfilesNotifierProvider).profiles.firstWhere(
              (element) => element.id == this.profile.id,
              orElse: () => this.profile,
            );
            final dateRange = useState(
      DateTimeRange(
        start: Dates.today.subtract(const Duration(days: 30)),
        end: Dates.today.add(const Duration(days: 1)).subtract(
              const Duration(microseconds: 1),
            ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: context.scheme.surfaceVariant,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ...[
                            (key: "ID", value: "#${profile.id}"),
                            (key: "Name", value: profile.name),
                            (key: "Email", value: profile.email ?? "-"),
                            (key: "Phone", value: profile.phoneNumber ?? "-"),
                            (key: "Location", value: profile.address ?? "-"),
                            (
                              key: "Gender",
                              value:
                                  context.labels.labelByGender(profile.gender)
                            ),
                            (
                              key: "Age",
                              value:
                                  profile.age != null ? "${profile.age}+" : "-"
                            ),
                            (
                              key: "Date Of Birth",
                              value: profile.dateOfBirth?.dateLabel2 ?? "-"
                            ),
                            (
                              key: "Joined At",
                              value: profile.createdAt?.dateTimeLabel ?? "-"
                            ),
                            (
                              key: "Channel",
                              value: profile.channel?.toUpperCase() ?? "-"
                            ),
                            (key: "Device ID", value: profile.deviceId ?? "-"),
                            (
                              key: "Device Name",
                              value: profile.deviceName ?? "-"
                            ),
                          ].map(
                            (e) => Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(e.key,
                                        style:
                                            context.style.titleMedium?.copyWith(
                                          color: context.scheme.outline,
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      e.value,
                                      style: context.style.titleMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                      child: Text(
                        'Subscription',
                        style: context.style.titleMedium
                            ?.copyWith(color: context.scheme.secondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: context.scheme.surfaceVariant,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: Text(
                          //           "Lifetime",
                          //           style: context.style.titleMedium?.copyWith(
                          //             color: context.scheme.outline,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          ...[
                            (
                              key: "Type",
                              value: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      profile.lifetime
                                          ? "Lifetime"
                                          : profile.premium
                                              ? "Premium"
                                              : "Free Trial",
                                      style: context.style.labelLarge?.copyWith(
                                        color: profile.lifetime
                                            ? Colors.pink
                                            : profile.premium
                                                ? Colors.teal
                                                : Colors.orange,
                                      ),
                                    ),
                                  ),
                                  if (!profile.lifetime) ...[
                                    const Text('Lifetime'),
                                    const SizedBox(width: 4),
                                  ],
                                  Switch(
                                    value: profile.lifetime,
                                    onChanged: ref.permissions.updateListners
                                        ? (v) async {
                                            try {
                                              await ref
                                                  .read(
                                                      profileRepositoryProvider)
                                                  .lifeTime(profile.id, v);

                                              ref
                                                  .read(
                                                      adminProfilesNotifierProvider
                                                          .notifier)
                                                  .pushProfile(
                                                    profile.copyWith(
                                                      lifetime: v,
                                                    ),
                                                  );
                                            } catch (e) {
                                              context.error(e);
                                            }
                                          }
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                            if (profile.premium)
                              (
                                key: "Status",
                                value: profile.expiryAt != null
                                    ? Text(
                                        profile.expired ? "Expired" : "Active",
                                        style:
                                            context.style.labelLarge?.copyWith(
                                          color: profile.expired
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            if (profile.periodType != null && profile.premium)
                              (
                                key: "Period Type",
                                value: Text(profile.periodType!),
                              ),
                            if (profile.purchasedAt != null && profile.premium)
                              (
                                key: "Purchased At",
                                value: profile.purchasedAt != null
                                    ? Text(
                                        profile.purchasedAt!.dateTimeLabel,
                                        style: context.style.labelLarge,
                                      )
                                    : const SizedBox(),
                              ),
                            if (!profile.lifetime &&
                                profile.premium &&
                                profile.expiryAt != null)
                              (
                                key: profile.expired
                                    ? "Expired At"
                                    : "Expires At",
                                value: profile.expiryAt != null
                                    ? Text(
                                        profile.expiryAt!.dateTimeLabel,
                                        style: context.style.labelLarge,
                                      )
                                    : const SizedBox(),
                              ),
                          ].map(
                            (e) => Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(e.key,
                                        style:
                                            context.style.titleMedium?.copyWith(
                                          color: context.scheme.outline,
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: e.value,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if ((!profile.premium ||
                                  (profile.premium && profile.expired)) &&
                              !profile.lifetime) ...[
                            OutlinedButton(
                              onPressed: ref.permissions.updateListners
                                  ? () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AddPurchaseDialog(profile: profile),
                                      );
                                    }
                                  : null,
                              child: const Text("Add Purchase"),
                            ),
                          ],
                          if (profile.premium &&
                              !profile.expired &&
                              profile.oldPurchase &&
                              !profile.lifetime)
                            OutlinedButton(
                              onPressed: ref.permissions.updateListners
                                  ? () async {
                                      ///confirmation
                                      final value = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Remove Purchase"),
                                          content: const Text(
                                              "Are you sure you want to remove the purchase?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text("Remove"),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (value == true) {
                                        final DateTime crAt =
                                            profile.createdAt ?? DateTime.now();
                                        try {
                                          await ref
                                              .read(profileRepositoryProvider)
                                              .removePremium(profile.id, crAt);
                                          ref
                                              .read(
                                                  adminProfilesNotifierProvider
                                                      .notifier)
                                              .pushProfile(
                                                profile.copyWith(
                                                  premium: false,
                                                  clearPurchasedAt: true,
                                                  expiryAt: crAt.add(
                                                      const Duration(days: 14)),
                                                  oldPurchase: false,
                                                ),
                                              );
                                        } catch (e) {
                                          context.error(e);
                                        }
                                      }
                                    }
                                  : null,
                              child: const Text("Remove Purchase"),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: OutlinedButton(
                        onPressed: () async {
                          final val = await showDialog(
                            context: context,
                            builder: (context) =>
                                DeleteUserDialog(profile: profile),
                          );
                          if (val == true) {
                            await ref
                                .read(clientProvider)
                                .from('users')
                                .delete()
                                .eq('id', profile.id);
                            ref
                                .read(adminProfilesNotifierProvider.notifier)
                                .removeUser(profile);
                            context.pop();
                          }
                        },
                        child: const Text("Delete user"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: ListView(
                children: [
                   DateRangeChipsView(dateRange: dateRange),
                   const SizedBox(height: 16,),
                  AsyncWidget(value: ref.watch(userSongListProvider(profile.id.toString(),'${dateRange.value.start.date}T00:00:00.00+00:00' )), 
                  data: (data){
                 return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'User Plays',
                              style: context.style.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            TableWrapper(
                              child: DataTable(
                                columns: const [
                                  DataColumn(
                                    label: Text('Track name'),
                                  ),
                                  DataColumn(
                                    label: Text('Play duration'),
                                  ),
                                  DataColumn(
                                    label: Text('Plays'),
                                  ),
                                 
                                ],
                                rows: data.map((e){
                                  
                                  var a = e.duration / e.totalDuration;
                                  
                                  return  DataRow(
                                    cells: [
                                      DataCell(
                                        Text(e.userTrack.nameEn),
                                      ),
                                      DataCell(
                                        Text(e.duration.toString().formatDuration(e.duration)),
                                      ),

                                      DataCell(
                                        Text(a.ceil().toString())
                                      )
                                    
                                    ],
                                  );
                                }).toList()
                                  // DataRow(
                                  //   cells: [
                                  //     DataCell(
                                  //       Text("${data.}"),
                                  //     ),
                                  //     DataCell(
                                  //       Text("${data.tracksCount}"),
                                  //     ),
                                    
                                  //   ],
                                  // ),
                                
                              ),
                            ),
                          ]
                        )
                 );
                  }
                        ),

                            const SizedBox(height: 16),
                  AsyncWidget(
                    value: ref
                        .watch(playSessionAnalyticsOfUserProvider(profile.id)),
                    data: (data) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Plays',
                              style: context.style.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            TableWrapper(
                              child: DataTable(
                                columns: const [
                                  DataColumn(
                                    label: Text('Total'),
                                  ),
                                  DataColumn(
                                    label: Text('Tracks'),
                                  ),
                                  DataColumn(
                                    label: Text('Categories'),
                                  ),
                                  DataColumn(
                                    label: Text('Artists'),
                                  ),
                                  DataColumn(
                                    label: Text('Playlists'),
                                  ),
                                  DataColumn(
                                    label: Text('Moods'),
                                  ),
                                ],
                                rows: [
                                  DataRow(
                                    cells: [
                                      DataCell(
                                        Text("${data.totalPlaySessions}"),
                                      ),
                                      DataCell(
                                        Text("${data.tracksCount}"),
                                      ),
                                      DataCell(
                                        Text("${data.categoriesCount}"),
                                      ),
                                      DataCell(
                                        Text("${data.artistsCount}"),
                                      ),
                                      DataCell(
                                        Text("${data.playlistsCount}"),
                                      ),
                                      DataCell(
                                        Text("${data.moodsCount}"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Most played tracks',
                              style: context.style.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            TableWrapper(
                              child: DataTable(
                                dataRowMinHeight: 32,
                                dataRowMaxHeight: 56,
                                columns: const [
                                  DataColumn(
                                    label: Text('Track'),
                                  ),
                                  DataColumn(
                                    label: Text('Artists'),
                                  ),
                                  DataColumn(
                                    label: Text('Plays'),
                                  ),
                                ],
                                rows: data.popularTrackIds.entries.map((e) {
                                  final track = ref
                                      .watch(adminTracksNotifierProvider)
                                      .tracks
                                      .where((element) => element.id == e.key)
                                      .firstOrNull;
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(track?.name(lang) ?? "#${e.key}"),
                                      ),
                                      DataCell(
                                        Text(track?.artistsLabel(ref, lang) ??
                                            ""),
                                      ),
                                      DataCell(
                                        Text("${e.value}"),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Most skipped tracks',
                              style: context.style.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            TableWrapper(
                              child: DataTable(
                                dataRowMinHeight: 32,
                                dataRowMaxHeight: 56,
                                columns: const [
                                  DataColumn(
                                    label: Text('Track'),
                                  ),
                                  DataColumn(
                                    label: Text('Artists'),
                                  ),
                                  DataColumn(
                                    label: Text('Skips'),
                                  ),
                                ],
                                rows: data.skippedTrackIds.entries.map((e) {
                                  final track = ref
                                      .watch(adminTracksNotifierProvider)
                                      .tracks
                                      .where((element) => element.id == e.key)
                                      .firstOrNull;
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(track?.name(lang) ?? "#${e.key}"),
                                      ),
                                      DataCell(
                                        Text(track?.artistsLabel(ref, lang) ??
                                            ""),
                                      ),
                                      DataCell(
                                        Text("${e.value}"),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Most played categories',
                              style: context.style.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            TableWrapper(
                              child: DataTable(
                                dataRowMinHeight: 32,
                                dataRowMaxHeight: 56,
                                columns: const [
                                  DataColumn(
                                    label: Text('Category'),
                                  ),
                                  DataColumn(
                                    label: Text('Plays'),
                                  ),
                                ],
                                rows: data.popularCategoryIds.entries.map((e) {
                                  final track = ref
                                      .watch(adminCategoriesNotifierProvider)
                                      .categories
                                      .where((element) => element.id == e.key)
                                      .firstOrNull;
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(track?.name() ?? "#${e.key}"),
                                      ),
                                      DataCell(
                                        Text("${e.value}"),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Most played artists',
                              style: context.style.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            TableWrapper(
                              child: DataTable(
                                dataRowMinHeight: 32,
                                dataRowMaxHeight: 56,
                                columns: const [
                                  DataColumn(
                                    label: Text('Artist'),
                                  ),
                                  DataColumn(
                                    label: Text('Plays'),
                                  ),
                                ],
                                rows: data.popularArtistIds.entries.map((e) {
                                  final track = ref
                                      .watch(adminArtistsNotifierProvider)
                                      .artists
                                      .where((element) => element.id == e.key)
                                      .firstOrNull;
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(track?.name() ?? "#${e.key}"),
                                      ),
                                      DataCell(
                                        Text("${e.value}"),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Most played playlists',
                              style: context.style.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            TableWrapper(
                              child: DataTable(
                                dataRowMinHeight: 32,
                                dataRowMaxHeight: 56,
                                columns: const [
                                  DataColumn(
                                    label: Text('Playlist'),
                                  ),
                                  DataColumn(
                                    label: Text('Plays'),
                                  ),
                                ],
                                rows: data.popularPlaylistIds.entries.map((e) {
                                  final track = ref
                                      .watch(adminPlaylistNotifierProvider)
                                      .playlists
                                      .where((element) => element.id == e.key)
                                      .firstOrNull;
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(track?.name(lang) ?? "#${e.key}"),
                                      ),
                                      DataCell(
                                        Text("${e.value}"),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Most played moods',
                              style: context.style.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            TableWrapper(
                              child: DataTable(
                                dataRowMinHeight: 32,
                                dataRowMaxHeight: 56,
                                columns: const [
                                  DataColumn(
                                    label: Text('Mood'),
                                  ),
                                  DataColumn(
                                    label: Text('Plays'),
                                  ),
                                ],
                                rows: data.popularMoodIds.entries.map((e) {
                                  final track = ref
                                      .watch(adminMoodsNotifierProvider)
                                      .moods
                                      .where((element) => element.id == e.key)
                                      .firstOrNull;
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(track?.name(lang) ?? "#${e.key}"),
                                      ),
                                      DataCell(
                                        Text("${e.value}"),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    },
                  ),
                  AsyncWidget(
                    value: ref.watch(adminLibraryItemsProvider(profile.id)),
                    data: (data) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Liked tracks',
                              style: context.style.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            TableWrapper(
                              child: DataTable(
                                dataRowMinHeight: 32,
                                dataRowMaxHeight: 56,
                                columns: const [
                                  DataColumn(
                                    label: Text('ID'),
                                  ),
                                  DataColumn(
                                    label: Text('Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Artists'),
                                  ),
                                ],
                                rows: data
                                    .where((element) =>
                                        element.type == LibraryItemType.track)
                                    .map((e) {
                                  final track = ref
                                      .watch(adminTracksNotifierProvider)
                                      .tracks
                                      .where(
                                          (element) => element.id == e.itemId)
                                      .firstOrNull;
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text("#${e.itemId}"),
                                      ),
                                      DataCell(
                                        Text(track?.name(lang) ?? "Unknown"),
                                      ),
                                      DataCell(
                                        Text(
                                            "${track?.artistsLabel(ref, lang)}"),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Other library items',
                              style: context.style.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            TableWrapper(
                              child: DataTable(
                                dataRowMinHeight: 32,
                                dataRowMaxHeight: 56,
                                columns: const [
                                  DataColumn(
                                    label: Text('Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Type'),
                                  ),
                                ],
                                rows: data
                                    .where((element) =>
                                        element.type != LibraryItemType.track &&
                                        element.type != LibraryItemType.unknown)
                                    .map((e) => MapEntry(
                                        e,
                                        switch (e.type) {
                                          LibraryItemType.artist => ref
                                              .read(
                                                  adminArtistsNotifierProvider)
                                              .artists
                                              .where((element) =>
                                                  element.id == e.itemId)
                                              .firstOrNull
                                              ?.name(lang),
                                          LibraryItemType.category => ref
                                              .read(
                                                  adminCategoriesNotifierProvider)
                                              .categories
                                              .where((element) =>
                                                  element.id == e.itemId)
                                              .firstOrNull
                                              ?.name(lang),
                                          LibraryItemType.mood => ref
                                              .read(adminMoodsNotifierProvider)
                                              .moods
                                              .where((element) =>
                                                  element.id == e.itemId)
                                              .firstOrNull
                                              ?.name(lang),
                                          LibraryItemType.playlist => ref
                                              .read(
                                                  adminPlaylistNotifierProvider)
                                              .playlists
                                              .where((element) =>
                                                  element.id == e.itemId)
                                              .firstOrNull
                                              ?.name(lang),
                                          _ => "",
                                        }))
                                    .map(
                                  (e) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(e.value ?? ""),
                                        ),
                                        DataCell(
                                          Text(e.key.type.name.toUpperCase()),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteUserDialog extends HookConsumerWidget {
  const DeleteUserDialog({super.key, required this.profile});

  final Profile profile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("Delete User"),
      content: const Text("Are you sure you want to delete user?"),
      actions: [
        OutlinedButton(
            onPressed: () async {
              context.pop(true);
            },
            child: const Text("Yes")),
        OutlinedButton(
            onPressed: () {
              context.pop(false);
            },
            child: const Text("No"))
      ],
    );
  }
}

class AddPurchaseDialog extends HookConsumerWidget {
  const AddPurchaseDialog({super.key, required this.profile});

  final Profile profile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expiryAt = useState<DateTime?>(null);
    final purchasedAt = useState<DateTime?>(null);
    final loading = useState<bool>(false);

    return AlertDialog(
      title: const Text("Add Purchase"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: purchasedAt.value ?? DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
              );
              if (picked != null) {
                purchasedAt.value = picked;
              }
            },
            initialValue: purchasedAt.value?.dateLabel3,
            key: ValueKey("${purchasedAt.value}-purchasedAt"),
            decoration: const InputDecoration(
              labelText: "Purchase Date",
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: expiryAt.value ??
                    DateTime.now().add(const Duration(days: 30)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
              );

              if (picked != null) {
                expiryAt.value = picked;
              }
            },
            initialValue: expiryAt.value?.dateLabel3,
            key: ValueKey("${expiryAt.value}-expiryAt"),
            decoration: const InputDecoration(
              labelText: "Expiry Date",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: loading.value
              ? null
              : purchasedAt.value != null && expiryAt.value != null
                  ? () async {
                      loading.value = true;
                      try {
                        await ref.read(profileRepositoryProvider).premium(
                            profile.id, purchasedAt.value!, expiryAt.value!);
                        ref
                            .read(adminProfilesNotifierProvider.notifier)
                            .pushProfile(
                              profile.copyWith(
                                premium: true,
                                purchasedAt: purchasedAt.value,
                                expiryAt: expiryAt.value,
                                oldPurchase: true,
                              ),
                            );
                      } catch (e) {
                        context.error(e);
                      }

                      context.pop();
                    }
                  : null,
          child: const Text("Add"),
        ),
      ],
    );
  }
}












// var res = await ref.read(clientProvider).from('play_sessions').select().filter('startedAt', 'gt', '2024-08-12T00:00:00.00+00:00').eq('userId', '64').select().select('tracks(id,nameEn),totalDuration,duration,rootType,rootId,startedAt,endedAt,userId');
//                                        print(res);

//                                      //  final List<dynamic> jsonResponse = json.decode(res);
//   final List<UserTodaySongs> models = res.map((data) => UserTodaySongs.fromJson(data)).toList();