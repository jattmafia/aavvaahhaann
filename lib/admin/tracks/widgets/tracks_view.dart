import 'package:avahan/admin/components/visibility_icon.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/core/models/track.dart';
import 'package:avahan/features/components/search_field.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminTracksView extends HookConsumerWidget {
  const AdminTracksView({super.key, required this.tracks, this.onRemove, this.bottomPadding});

  final List<Track> tracks;

  final Function(Track track)? onRemove;

  final double? bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    final searchKey = useState('');

    final results = tracks
        .where((element) =>
            element.searchString.contains(searchKey.value.toLowerCase()))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: SearchField(
                  initial: searchKey.value,
                  hintText: "Search by name",
                  onChanged: (value) => searchKey.value = value,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('${results.length} tracks'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(
              bottom: bottomPadding ?? 0,
            ),
            children: results
                .map(
                  (e) => ListTile(
                    onTap: () {
                      ref.read(dataViewProvider.notifier).show(e);
                    },
                    leading: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: e.icon(lang),
                      ),
                    ),
                    title: Row(
                      children: [
                        Flexible(child: Text(e.name(lang))),
                        const SizedBox(width: 8),
                        VisibilityIcon(e.active),
                      ],
                    ),
                    subtitle: Text(e.artistsLabel(ref, lang)),
                    trailing: onRemove != null
                        ? IconButton(
                            onPressed: () async {
                              onRemove!(e);
                            },
                            icon: const Icon(Icons.remove),
                          )
                        : null,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
