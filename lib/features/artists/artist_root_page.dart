import 'package:avahan/features/artists/artist_page.dart';
import 'package:avahan/features/artists/providers/artists_provider.dart';
import 'package:avahan/features/artists/widgets/artist_tile.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArtistRootPage extends ConsumerWidget {
  const ArtistRootPage({super.key, required this.ids});

  static const route = '/artist-root';
  final List<int> ids;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AsyncWidget(
        value: ref.watch(artistsProvider),
        data: (data) {
          final filtered = data.where((element) => ids.contains(element.id));
          if (filtered.length == 1) {
            return ArtistPage(
              artist: filtered.first,
            );
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: ListView(
                children: filtered.map((e) => ArtistTile(e: e)).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
