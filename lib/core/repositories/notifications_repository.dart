import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/notify_event.dart';
import 'package:avahan/core/models/push_notification.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:avahan/core/repositories/functions_repository.dart';
import 'package:avahan/core/repositories/storage_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final notificationsRepositoryProvider = Provider(NotificationsRepository.new);

class NotificationsRepository {
  final Ref _ref;

  NotificationsRepository(this._ref);

  static const _notifications = 'push_notifications';

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  StorageRepository get _storage => _ref.read(storageRepositoryProvider);

  Future<void> write(
    PushNotification notification, {
    XFile? image,
  }) async {
    try {
      if (image != null) {
        final url = await _storage.upload(
          _notifications,
          image,
        );
        notification = notification.copyWith(image: url);
      }

      if (notification.frequency == null) {
        final result = await _ref
            .read(functionsRepositoryProvider)
            .sendNotification(notification);

        notification = notification.copyWith(
          results: [
            ...notification.results,
            result,
          ],
        );
      }

      await _client
          .from(_notifications)
          .upsert(notification
              .copyWith(
                createdAt: DateTime.now(),
              )
              .toMap())
          .select();
    } on Exception catch (e) {
      print(e);
      return Future.error(e.parse);
    }
  }

  Future<List<PushNotification>> list({
    DateTime? date,
    DateTime? endDate,
    bool scheduled = false,
    bool template = false,
  }) async {
    try {
      var query = _client.from(_notifications).select();

      if (date != null) {
        query = query
            .gte('createdAt', date.toIso8601String())
            .lt(
              'createdAt',
              (endDate?? date).add(const Duration(days: 1)).toIso8601String(),
            )
            .isFilter('frequency', null);
      }
      if (scheduled) {
        query = query.not('frequency', 'is', null);
      }

      if (template) {
        query = query.eq('template', true);
      }

      final supabase.PostgrestList result =
          await query.order('updatedAt', ascending: false, nullsFirst: true);
      return result
          .map(
            (e) => PushNotification.fromMap(
              e,
            ),
          )
          .toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> delete(int id) async {
    try {
      await _client.from(_notifications).delete().eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateActive(int id, bool active) async {
    try {
      await _client.from(_notifications).update({
        'active': active,
      }).eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateTemplate(int id, bool value) async {
    try {
      await _client.from(_notifications).update({
        'template': value,
      }).eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }



  Future<void> createSend(NotifyEvent event){
    return _client.from('sends').insert(event.toMap());
  }

  Future<void> createOpen(NotifyEvent event){
    return _client.from('opens').insert(event.toMap());
  }
}
