import 'package:avahan/admin/components/visibility_icon.dart';
import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/core/models/artist.dart';
import 'package:avahan/features/components/search_field.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminArtistsView extends HookConsumerWidget {
  const AdminArtistsView({super.key, required this.artists, this.onRemove});

  final List<Artist> artists;

  final Function(Artist artist)? onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    final searchKey = useState('');

    final results = artists
        .where((element) =>
            element.searchString.contains(searchKey.value.toLowerCase()))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
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
                  child: Text('${results.length} artists'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: results
                .map(
                  (e) => ListTile(
                                        onTap: () {
                      ref.read(dataViewProvider.notifier).show(e);
                    },
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(e.icon(lang)),
                    ),
                    subtitle: Text("${e.tracksCount(ref)} tracks"),
                    title: Row(
                      children: [
                        Flexible(child: Text(e.name(lang))),
                        const SizedBox(width: 8),
                        VisibilityIcon(e.active),
                      ],
                    ),
                    trailing: onRemove != null? IconButton(
                      onPressed: () {
                        onRemove!(e);
                      },
                      icon: const Icon(Icons.remove),
                    ): null,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
