// ignore_for_file: use_build_context_synchronously

import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/providers/cache_manager_provider.dart';
import 'package:avahan/core/providers/cache_tracks_provider.dart';
import 'package:avahan/core/providers/player_provider.dart';

import 'package:avahan/features/components/description_text.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:avahan/features/subscriptions/providers/premium_provider.dart';
import 'package:avahan/features/subscriptions/track_access_provider.dart';
import 'package:avahan/features/tracks/providers/play_notifier_provider.dart';
import 'package:avahan/features/view/models/view_state.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ViewPage extends HookConsumerWidget {
  const ViewPage({super.key, required this.view, required this.body});

  final ViewState view;

  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = view.cover;

    final memorised = useMemoized(
        () => ColorScheme.fromImageProvider(
              provider: CachedNetworkImageProvider(image),
            ),
        []);

    final schemeAsync = useFuture(memorised);

    final colorScheme = schemeAsync.data ?? context.scheme;

    final controller = useScrollController();

    final gradientHeight =
        context.size_.width * 2 / 3 - kToolbarHeight - context.padding.top;

    final offset = useState(0.0);

    useEffect(() {
      controller.addListener(() {
        offset.value = controller.offset;
      });
    }, []);

    final progress = (offset.value / gradientHeight).clamp(0.0, 1).toDouble();
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: context.size_.width * 2 / 3 + context.padding.top,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: ColorTween(
                  begin: colorScheme.primaryContainer.withOpacity(0),
                  end: colorScheme.primaryContainer,
                ).transform((progress * 1.25).clamp(0, 1))!,
                leadingWidth: 16 + kToolbarHeight,
                leading: Container(
                  margin: const EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primaryContainer.withOpacity(0.5),
                  ),
                  child: BackButton(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                titleTextStyle: TextStyle(
                  color: ColorTween(
                    begin: colorScheme.onPrimaryContainer.withOpacity(0),
                    end: colorScheme.onPrimaryContainer,
                  ).transform(((progress - 0.5) / 0.5).clamp(0, 1))!,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                title: Text(view.name),
                actions: [
                  if (view.onShareTap != null)
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primaryContainer.withOpacity(0.5),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          view.onShareTap!();
                        },
                        icon: const Icon(Icons.share),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  controller: controller,
                  children: [
                    Container(
                      height: gradientHeight,
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorTween(
                              begin:
                                  colorScheme.primaryContainer.withOpacity(0.0),
                              end: colorScheme.primaryContainer,
                            ).transform(progress)!,
                            // colorScheme.primaryContainer.withOpacity(0),
                            // colorScheme.primaryContainer.withOpacity(0.25),
                            ColorTween(
                              begin: colorScheme.primaryContainer
                                  .withOpacity(0.75),
                              end: colorScheme.primaryContainer,
                            ).transform(progress)!,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        view.name,
                        style: context.style.displaySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    Container(
                      color: colorScheme.surface,
                      child: Stack(
                        children: [
                          Container(
                            height: context.size_.width,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primaryContainer,
                                  colorScheme.primaryContainer.withOpacity(0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          body,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ViewPageBody extends ConsumerWidget {
  const ViewPageBody({super.key, required this.view});
  final ViewState view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.read(yourProfileProvider).value!;
    final premium = ref.read(premiumProvider).asData?.value ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (view.description != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DescriptionText(
              view.description!,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  ref.authorized(ref, () {
                    view.onLibraryTap();
                  });
                },
                icon: view.isInLibrary
                    ? const Icon(
                        Icons.library_add_check,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.library_add_outlined,
                      ),
              ),
              if (view.tracks.isNotEmpty)
                ValueListenableBuilder(
                  valueListenable:
                      ref.read(cacheTracksProvider).value!.listenable(),
                  builder: (context, Box<Track> box, child) {
                    final tracks = box.values
                        .where((element) =>
                            view.tracks.map((e) => e.id).contains(element.id))
                        .toList();

                    final downloaded = tracks.length == view.tracks.length;

                    return downloaded
                        ? HookBuilder(builder: (
                            context,
                          ) {
                            final progress = useState<double>(0);

                            useEffect(() {
                              final Map<String, double> progressMap = {};
                              for (final url in tracks.map((e) => e.url)) {
                                final fileStream = ref
                                    .read(cacheManagerProvider)
                                    .getFileStream(url, withProgress: true);
                                fileStream.listen((event) {
                                  if (event is DownloadProgress) {
                                    progressMap[url] = event.progress ?? 0;
                                  } else if (event is FileInfo) {
                                    progressMap[url] = 1;
                                    if (progressMap.entries.length ==
                                        tracks.length) {
                                      progress.value = progressMap.values.fold(
                                              0.0,
                                              (previousValue, element) =>
                                                  previousValue + element) /
                                          progressMap.length;
                                    }
                                  }
                                });
                              }
                              return null;
                            }, [tracks.length]);

                            return progress.value < 1
                                ? IconButton(
                                    onPressed: () {},
                                    icon: const DownloadIconShaderMask(),
                                  )
                                : IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.download_done,
                                      color: Colors.green,
                                    ),
                                  );
                          })
                        : IconButton(
                            onPressed: () {
                              if (premium) {
                                for (var track in view.tracks) {
                                  if (box.get('track_${track.id}') == null) {
                                    box.put('track_${track.id}', track);
                                  }
                                }
                              } else {
                                ref.authorized(ref, () {
                                  context.showPremiumSnackbar(ref);
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.download_for_offline_outlined,
                            ),
                          );
                  },
                ),
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.more_vert_rounded),
              // ),
              const Spacer(),
             if(view.tracks.where((element) => ref.read(trackAccessProvider(element.id))).isNotEmpty) StreamBuilder(
                  stream: ref.watch(playerProvider).playingStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;
                    return IconButton.filled(
                      onPressed: () {
                        if (!playing) {
                          view.onPlayTap();
                        } else {
                          ref
                              .read(playNotifierProvider.notifier)
                              .pausePlaySession();
                        }
                      },
                      icon: Icon(view.isPlaying && playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded),
                    );
                  }),
              const SizedBox(width: 16),
            ],
          ),
        ),
        view.child,
      ],
    );
  }
}

class DownloadIconShaderMask extends StatefulWidget {
  const DownloadIconShaderMask({super.key});
  @override
  State<DownloadIconShaderMask> createState() => _DownloadIconShaderMaskState();
}

class _DownloadIconShaderMaskState extends State<DownloadIconShaderMask>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat(reverse: true);

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green, Colors.green.withOpacity(0.25)],
          stops: [_animation.value, _animation.value + 0.1],
        ).createShader(bounds);
      },
      child: const ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
        child: Icon(Icons.downloading_rounded),
      ),
    );
  }
}
