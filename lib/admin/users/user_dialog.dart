import 'package:avahan/admin/users/providers/users_provider.dart';
import 'package:avahan/core/models/admin_user.dart';
import 'package:avahan/core/repositories/admin_repository.dart';
import 'package:avahan/utils/extensions.dart';
import 'package:avahan/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminUserDialog extends HookConsumerWidget {
  const AdminUserDialog({super.key,required this.user});
  
  final AdminUser user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final formKey = useRef(GlobalKey<FormState>());
    final permissions = useState<List<String>>(user.permissions);

    final loading = useState<bool>(false);

    final list = [
      [
        'view-listners',
        'update-listners',
      ],
      [
        'view-categories',
        'create-categories',
        'update-categories',
        'delete-categories',
      ],
      [
        'view-artists',
        'create-artists',
        'update-artists',
        'delete-artists',
      ],
      [
        'view-playlists',
        'create-playlists',
        'update-playlists',
        'delete-playlists',
      ],
      [
        'view-tracks',
        'create-tracks',
        'update-tracks',
        'delete-tracks',
      ],
      [
        'view-moods',
        'create-moods',
        'update-moods',
        'delete-moods',
      ],
      [
        'manage-settings',
        'manage-notifications',
        'manage-users',
      ]
    ];
    return AlertDialog(
      title: Text(user.name),
      content: Form(
        key: formKey.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Permissions'),
            const SizedBox(height: 8),
            ...list.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: e.map((e) {
                    return FilterChip(
                      label:
                          Text(e.split('-').map((e) => e.capLabel).join(' ')),
                      selected: permissions.value.contains(e),
                      onSelected: (value) {
                        permissions.value = value
                            ? [...permissions.value, e]
                            : permissions.value.where((i) => i != e).toList();
                      },
                    );
                  }).toList(),
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: loading.value
              ? null
              : () async {
                  if (formKey.value.currentState!.validate()) {
                    loading.value = true;
                    try {
                      await ref.read(adminRepositoryProvider).editUser(
                            id: user.id,
                            permissions: permissions.value,
                          );
                      await ref.refresh(adminUsersProvider.future);
                      context.pop();
                    } catch (e) {
                      print(e);
                      loading.value = false;
                      context.error(e);
                    }
                  }
                },
          child: Text('Save'),
        ),
      ],
    );
  }
}
