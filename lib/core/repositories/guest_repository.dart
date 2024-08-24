import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/guest.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/providers/client_provider.dart';

final guestRepositoryProvider = Provider(GuestRepository.new);

class GuestRepository {
  final Ref _ref;

  GuestRepository(this._ref);

  static const _guests = 'guests';

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  // StorageRepository get _storage => _ref.read(storageRepositoryProvider);

  Future<Guest> getGuestFromDeviceId(String deviceId) async {
    try {
      final data = await _client
          .from(_guests)
          .select('*')
          .eq('deviceId', deviceId)
          .single();
      return Guest.fromMap(data);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> writeGuest(
    Guest guest,
  ) async {
    try {
      await _client.from(_guests).upsert(
            guest.toMap(),
          );
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> langUpdate(int id, Lang lang) async {
    try {
      await _client.from(_guests).update({
        'lang': lang.name,
      }).eq(
        'id',
        id,
      );
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateFcmToken(int id, String fcmToken) async {
    try {
      await _client.from(_guests).update({"fcmToken": fcmToken}).eq('id', id);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }
}
