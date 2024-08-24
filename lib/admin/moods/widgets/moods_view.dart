import 'package:avahan/admin/data/providers/data_view_notifier.dart';
import 'package:avahan/core/models/mood.dart';
import 'package:avahan/features/components/search_field.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminMoodsView extends HookConsumerWidget {
  const AdminMoodsView({super.key, required this.moods, this.onRemove});

  final List<Mood> moods;

  final Function(Mood mood)? onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.lang;
    final searchKey = useState('');

    final results = moods
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
                    title: Text(e.name(lang)),
                    subtitle: Text("${e.tracksCount(ref)} tracks"),
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
