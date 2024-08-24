import 'package:avahan/admin/users/providers/users_provider.dart';
import 'package:avahan/core/models/admin_user.dart';
import 'package:avahan/features/auth/providers/session_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension WidgetRefExtension on WidgetRef {
  AdminUser get admin {
    return watch(adminUsersProvider).asData?.value.firstWhere(
              (e) => e.uid == read(sessionProvider)!.user.id,
              orElse: () => AdminUser(
                  id: 0, name: '', email: '', permissions: [], uid: ''),
            ) ??
        AdminUser(id: 0, name: '', email: '', permissions: [], uid: '');
  }

  bool permission(String permission) {
    return admin.permissions.contains(permission);
  }


  ({
    bool createArtists,
    bool createCategories,
    bool createMoods,
    bool createPlaylists,
    bool createTracks,
    bool deleteArtists,
    bool deleteCategories,
    bool deleteMoods,
    bool deletePlaylists,
    bool deleteTracks,
    bool manageNotifications,
    bool manageSettings,
    bool manageUsers,
    bool updateArtists,
    bool updateCategories,
    bool updateListners,
    bool updateMoods,
    bool updatePlaylists,
    bool updateTracks,
    bool viewArtists,
    bool viewCategories,
    bool viewListners,
    bool viewMoods,
    bool viewPlaylists,
    bool viewTracks
  }) get permissions => (
      viewListners: permission('view-listners'),
      updateListners: permission('update-listners'),
      viewCategories: permission('view-categories'),
      createCategories: permission('create-categories'),
      updateCategories: permission('update-categories'),
      deleteCategories: permission('delete-categories'),
      viewArtists: permission('view-artists'),
      createArtists: permission('create-artists'),
      updateArtists: permission('update-artists'),
      deleteArtists: permission('delete-artists'),
      viewPlaylists: permission('view-playlists'),
      createPlaylists: permission('create-playlists'),
      updatePlaylists: permission('update-playlists'),
      deletePlaylists: permission('delete-playlists'),
      viewTracks: permission('view-tracks'),
      createTracks: permission('create-tracks'),
      updateTracks: permission('update-tracks'),
      deleteTracks: permission( 'delete-tracks'),
      viewMoods: permission('view-moods'),
      createMoods: permission('create-moods'),
      updateMoods: permission('update-moods'),
      deleteMoods: permission('delete-moods'),
      manageSettings: permission('manage-settings'),
      manageNotifications: permission('manage-notifications'),
      manageUsers: permission('manage-users'),
    );
}
