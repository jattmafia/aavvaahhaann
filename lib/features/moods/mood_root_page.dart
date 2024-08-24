import 'package:avahan/features/components/async_widget.dart';
import 'package:avahan/features/moods/mood_page.dart';
import 'package:avahan/features/moods/providers/moods_provider.dart';
import 'package:avahan/features/moods/widgets/mood_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MoodRootPage extends ConsumerWidget {
  const MoodRootPage({super.key, required this.ids});

  static const route = '/mood-root';
  final List<int> ids;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AsyncWidget(
        value: ref.watch(moodsProvider),
        data: (data) {
          final filtered = data.where((element) => ids.contains(element.id));
          if (filtered.length == 1) {
            return MoodPage(mood: filtered.first,);
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: ListView(
                children: filtered.map((e) => MoodTile(e: e)).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}