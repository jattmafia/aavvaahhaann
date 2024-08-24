import 'package:avahan/core/models/track.dart';
import 'package:avahan/core/repositories/track_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'tracks_provider.g.dart';

@riverpod
FutureOr<List<Track>> tracks(TracksRef ref, {
  int? categoryId,
  int? moodId,
  int? artistId,
  List<int>? ids,
  String? searchKey
}) {
  return ref.read(trackRepositoryProvider).listActive(
    artistId: artistId,
    categoryId: categoryId,
    moodId: moodId,
    ids: ids,
    searchKey: searchKey,
  );
}
