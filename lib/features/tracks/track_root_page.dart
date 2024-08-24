import 'package:avahan/core/models/play_group.dart';
import 'package:avahan/features/tracks/providers/play_notifier_provider.dart';
import 'package:avahan/features/tracks/providers/track_provider.dart';
import 'package:avahan/features/tracks/track_page.dart';
import 'package:avahan/features/tracks/widgets/track_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TrackRootPage extends HookConsumerWidget {
  const TrackRootPage({super.key, required this.ids});

  static const route = '/track-root';
  final List<int> ids;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i = useState(false);
    useEffect(() {
      if (ids.length == 1) {
        ref.read(trackProvider(ids.first).future).then((value) {
          Future.delayed(Duration.zero,(){
            ref.read(playNotifierProvider.notifier).startPlaySession(
                PlayGroup(data: value, tracks: [value], start: value),
              );
          i.value = true;
          });
        });
      }
    }, []);
    return Scaffold(
      appBar: ids.length > 1? AppBar(): null,
      body: ids.length == 1
          ? i.value? const TrackPage(): const Center(child: CircularProgressIndicator())
          : ListView(
              children: ids
                  .map(
                    (e) => ref.watch(trackProvider(e)).when(
                          data: (track) {
                            return TrackTile(e: track);
                          },
                          error: (e, s) => const SizedBox(),
                          loading: () => const ListTile(),
                        ),
                  )
                  .toList(),
            ),
    );
  }
}
