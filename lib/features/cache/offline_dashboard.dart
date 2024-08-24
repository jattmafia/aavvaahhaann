// ignore_for_file: unused_result

import 'package:avahan/core/providers/internet_connection_provider.dart';
import 'package:avahan/features/artists/providers/artists_provider.dart';
import 'package:avahan/features/cache/cache_tracks_page.dart';
import 'package:avahan/features/components/internet_tile.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/features/tracks/widgets/player_tile.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OfflineDashboard extends HookConsumerWidget {
  const OfflineDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        ref.refresh(yourProfileProvider);
        if (ref.read(artistsProvider).hasError) {
          ref.refresh(artistsProvider);
        }
      },
      [ref.watch(internetConnectionProvider).asData?.value],
    );
    return const Scaffold(
      body: CacheTracksPage(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PlayerTile(),
          InternetTile(showAction: false),
        ],
      ),
    );
  }
}
