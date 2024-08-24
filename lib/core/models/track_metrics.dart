import 'package:avahan/core/enums/avahan_data_type.dart';

class TrackMetrics {
  final int likes;
  final int count;
  final int skips;
  final List<RootTrackMetrics> roots;
  
  TrackMetrics({
    required this.likes,
    required this.count,
    required this.skips,
    required this.roots,
  });

  TrackMetrics copyWith({
    int? likes,
    int? count,
    int? skips,
    List<RootTrackMetrics>? roots,
  }) {
    return TrackMetrics(
      likes: likes ?? this.likes,
      count: count ?? this.count,
      skips: skips ?? this.skips,
      roots: roots ?? this.roots,
    );
  }

  factory TrackMetrics.fromMap(Map<String, dynamic> map) {
    return TrackMetrics(
      likes: map['likes'] as int,
      count: map['count'] as int,
      skips: map['skips'] as int,
      roots: List<RootTrackMetrics>.from((map['roots'] as Iterable).map<RootTrackMetrics>((x) => RootTrackMetrics.fromMap(x as Map<String,dynamic>),),),
    );
  }
}


class RootTrackMetrics {
  final int rootId;
  final AvahanDataType rootType;
  final int count;
  RootTrackMetrics({
    required this.rootId,
    required this.rootType,
    required this.count,
  });

  factory RootTrackMetrics.fromMap(Map<String, dynamic> map) {
    return RootTrackMetrics(
      rootId: map['rootId'] as int,
      rootType: AvahanDataType.values.firstWhere(
        (e) => e.name == map['rootType'],
        orElse: () => AvahanDataType.unknown,
      ),
      count: map['count'] as int,
    );
  }
}
