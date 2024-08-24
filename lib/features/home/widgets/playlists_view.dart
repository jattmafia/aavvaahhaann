

import 'package:avahan/core/extensions.dart';
import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/playlists/playlist_page.dart';
import 'package:avahan/features/playlists/providers/playlists_provider.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlaylistsView extends ConsumerWidget {
  const PlaylistsView({
    super.key,
    this.ids,
  });

  final List<int>? ids;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    return AsyncWidget(
      value: ref.watch(playlistsProvider),
      data: (data) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(12).copyWith(top: 4),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.where((element) => ids?.contains(element.id) ?? true).toList()
                  .sortByName()
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: 128,
                        child: GestureDetector(
                          onTap: () async {
                            context.push(PlaylistPage.route,
                                extra: e, ref: ref);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        e.icon(lang),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                e.name(lang),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList()),
        );
      },
    );
  }
}
