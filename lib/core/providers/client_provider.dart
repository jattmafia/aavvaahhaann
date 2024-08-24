import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

final clientProvider = Provider<supabase.SupabaseClient>(
  (ref) => supabase.Supabase.instance.client,
);
