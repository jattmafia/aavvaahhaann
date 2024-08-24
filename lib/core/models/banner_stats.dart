import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first


class BannerStats {

  final int today;
  final int total;
  final int last7Days;
  final int thisMonth;
  final int last30Days;

  
  BannerStats({
    required this.today,
    required this.total,
    required this.last7Days,
    required this.thisMonth,
    required this.last30Days,
  });






  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'today': today,
      'total': total,
      'last7Days': last7Days,
      'thisMonth': thisMonth,
      'last30Days': last30Days,
    };
  }

  factory BannerStats.fromMap(Map<String, dynamic> map) {
    return BannerStats(
      today: map['today'] as int,
      total: map['total'] as int,
      last7Days: map['last7Days'] as int,
      thisMonth: map['thisMonth'] as int,
      last30Days: map['last30Days'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerStats.fromJson(String source) => BannerStats.fromMap(json.decode(source) as Map<String, dynamic>);
}

  // {
  //       "today": 1,
  //       "total": 1,
  //       "last7Days": 1,
  //       "thisMonth": 1,
  //       "last30Days": 1
  //     }