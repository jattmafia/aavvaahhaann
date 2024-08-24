class RootPlaySessionMetrics {
  final int count;
  final Map<int, int> tracks;
  
  RootPlaySessionMetrics({
    required this.count,
    required this.tracks,
  });

  factory RootPlaySessionMetrics.fromMap(Map<String, dynamic> map) {
    return RootPlaySessionMetrics(
      count: map['count'] as int,
      tracks: Map<int, int>.fromEntries(
        (map['tracks'] as Iterable).map(
          (e) => MapEntry(e['id'] as int, e['count'] as int),
        ),
      ),
    );
  }
}
