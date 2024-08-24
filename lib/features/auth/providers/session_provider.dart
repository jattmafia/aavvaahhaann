import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final sessionProvider = Provider<supabase.Session?>(
  (ref) => supabase.Supabase.instance.client.auth.currentSession,
);
