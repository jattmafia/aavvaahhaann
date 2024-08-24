import 'package:avahan/core/models/debouncer.dart';
import 'package:avahan/core/models/push_notification.dart';
import 'package:avahan/core/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileSearchView extends HookConsumerWidget {
  const ProfileSearchView({
    super.key,
    required this.onSelected,
    required this.notification,
    required this.alreadySelected,
  });

  final Function(List<int> values) onSelected;

  final List<int> alreadySelected;

  final PushNotification notification;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SearchAnchor(
      viewElevation: 4,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          hintText: "Search by name",
          elevation: const MaterialStatePropertyAll(1),
          controller: controller,
          padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return [
          HookConsumer(
            builder: (context, ref, child) {
              final selected = useState<List<int>>([]);
              final searchKey = useState<String>("");
              final debouncer = useRef(
                Debouncer(
                  const Duration(milliseconds: 500),
                  (value) {
                    searchKey.value = value;
                  },
                ),
              );
              if (debouncer.value.value != controller.text) {
                debouncer.value.value = controller.text;
              }

              final memoried = useMemoized(
                () async {
                  return await ref
                      .read(profileRepositoryProvider)
                      .paginateProfilesForSearch(
                        page: 0,
                        name: int.tryParse(searchKey.value) == null &&
                                !searchKey.value.contains('@')
                            ? searchKey.value
                            : null,
                        id: int.tryParse(searchKey.value) != null &&
                                searchKey.value.length < 6
                            ? int.parse(searchKey.value)
                            : null,
                        phoneNumber: int.tryParse(searchKey.value) != null &&
                                searchKey.value.length >= 10
                            ? searchKey.value
                            : null,
                        email: searchKey.value.contains('@')
                            ? searchKey.value
                            : null,
                        ageMax: notification.ageMax,
                        ageMin: notification.ageMin,
                        birthday: notification.birthday,
                        city: notification.city,
                        country: notification.country,
                        expired: notification.expired,
                        gender: notification.gender,
                        lang: notification.lang,
                        premium: notification.premium,
                        //state: notification.state!.name,
                        channel: notification.channel,
                      );
                },
                [searchKey.value],
              );

              final asyncValue = useFuture(memoried);

              return asyncValue.hasData
                  ? Column(
                      children: asyncValue.data!.$2
                          .where((element) =>
                              !alreadySelected.contains(element.id))
                          .map(
                            (e) => ListTile(
                              leading: Text('#${e.id}'),
                              title: Text(e.name),
                              subtitle: Text(e.phoneNumber ?? e.email ?? ""),
                              onTap: () {
                                onSelected([e.id]);
                                controller.closeView('');
                              },
                            ),
                          )
                          .toList(),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
        ];
      },
    );
  }
}
