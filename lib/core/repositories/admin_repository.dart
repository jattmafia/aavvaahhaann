import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/admin_user.dart';
import 'package:avahan/core/providers/client_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart';

final adminRepositoryProvider = Provider(
  (ref) => AdminRepository(ref),
);

class AdminRepository {
  final Ref _ref;

  AdminRepository(this._ref);

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  Future<void> addUser({
    required String email,
    required String name,
    required List<String> permissions,
  }) async {
    try {
      final res = await _client.functions.invoke("add_admin", headers: {
        'Content-Type': 'application/json; charset=utf-8',
      }, body: {
        'email': email,
        'name': name,
        'permissions': permissions,
      });
    } on Exception catch (e) {
      return Future.error(e.parse);
    } on FunctionException catch (e) {
      print(e.details);
      print(e.reasonPhrase);
      return Future.error(e);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<void> editUser({
    required int id,
    required List<String> permissions,
  }) async {
    try {
      final res = await _client.functions.invoke("edit_admin", headers: {
        'Content-Type': 'application/json; charset=utf-8',
      }, body: {
        'id': id,
        'permissions': permissions,
      });
    } on Exception catch (e) {
      return Future.error(e.parse);
    } on FunctionException catch (e) {
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> deleteUser({
    required int id,
    required String uid,
  }) async {
    try {
      final res = await _client.functions.invoke("delete_admin", headers: {
        'Content-Type': 'application/json; charset=utf-8',
      }, body: {
        'id': id,
        'uid': uid,
      });
    } on Exception catch (e) {
      return Future.error(e.parse);
    } on FunctionException catch (e) {
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<AdminUser>> listAdminUsers() async {
    final Iterable res = await _client.from('admins').select('*');
    return res.map((e) => AdminUser.fromMap(e)).toList();
  }
}
