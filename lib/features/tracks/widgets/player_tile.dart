// ignore_for_file: prefer_const_constructors

import 'package:avahan/core/providers/lang_provider.dart';
import 'package:avahan/core/providers/player_provider.dart';
import 'package:avahan/features/tracks/providers/play_notifier_provider.dart';
import 'package:avahan/features/tracks/track_page.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayerTile extends ConsumerWidget {
  const PlayerTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playNotifierProvider);
    final notifier = ref.read(playNotifierProvider.notifier);
    final lang = ref.watch(langProvider);

    final player = ref.read(playerProvider);

    if (state.session == null) {
      return SizedBox.shrink();
    }

    return StreamBuilder(
      stream: player.currentIndexStream,
      builder: (context, snapshot) {
        final index = snapshot.data ?? 0;
        final track = notifier.track(index);
        return StreamBuilder(
          stream: player.positionStream,
          builder: (context, snapshot) {
            final duration = player.duration ?? Duration.zero;
            final position = snapshot.data ?? Duration.zero;
            return GestureDetector(
              onTap: () {
                context.push(TrackPage.route);
              },
              child: HookConsumer(
                builder: (context, ref, child) {
                  final memorised = useMemoized(
                    () => ColorScheme.fromImageProvider(
                      provider:
                          CachedNetworkImageProvider(track.cover(lang)),
                    ),
                    [track.id],
                  );

                  final schemeAsync = useFuture(memorised);

                  final scheme = schemeAsync.data ?? context.scheme;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    height: 56,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl: track.icon(lang),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            track.name(lang),
                                            maxLines: 1,
                                            style: context.style.titleSmall,
                                          ),
                                          Text(
                                            track.artistsLabel(ref, lang),
                                            maxLines: 1,
                                            style: context.style.bodySmall!
                                                .copyWith(
                                              color: context.scheme.onSurface
                                                  .withOpacity(0.75),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            StreamBuilder<bool>(
                              initialData: player.playing,
                              stream: player.playingStream,
                              builder: (context, snapshot) {
                                final playing =
                                    duration.inSeconds == position.inSeconds
                                        ? false
                                        : (snapshot.data ?? false);
                                return IconButton(
                                  onPressed: () {
                                    if (playing) {
                                      notifier.pausePlaySession();
                                    } else {
                                      if (position.inSeconds ==
                                          duration.inSeconds) {
                                        notifier.replayPlaySession();
                                      } else {
                                        notifier.resumePlaySession();
                                      }
                                    }
                                  },
                                  color: context.scheme.primary,
                                  iconSize: 32,
                                  icon: playing
                                      ? const Icon(
                                          Icons.pause_rounded,
                                        )
                                      : const Icon(
                                          Icons.play_arrow_rounded,
                                        ),
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                        if (duration.inSeconds > 0)
                          Positioned(
                            right: 8,
                            left: 8,
                            bottom: 0,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 2,
                                    width: constraints.maxWidth *
                                        (position.inSeconds /
                                            duration.inSeconds),
                                    color: context.scheme.primary,
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
