import 'package:avahan/admin/artists/providers/artists_notifier.dart';
import 'package:avahan/features/components/search_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArtistsPickerDialog extends HookConsumerWidget {
  const ArtistsPickerDialog({super.key, required this.values});

  final List<int> values;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = useState<List<int>>(values);
    return AlertDialog(
      content: SizedBox(
        width: 400,
        child: Column(
          children: [
            SearchField(
              hintText: "Search by name",
            ),
            const SizedBox(height: 16),
            ...ref.watch(adminArtistsNotifierProvider).artists.map(
                  (e) => ListTile(
                    onTap: (){},
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(e.icon()),
                    ),
                    title: Text(
                      e.name(),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
