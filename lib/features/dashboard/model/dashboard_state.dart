// ignore_for_file: public_member_api_docs, sort_constructors_first
class DashboardState {
  final int index;
  final dynamic data;

  DashboardState({
    required this.index,
     this.data,
  });

  DashboardState copyWith({
    int? index,
    dynamic data,
    bool clearData = false,
  }) {
    return DashboardState(
      index: index ?? this.index,
      data: clearData ? null : data ?? this.data,
    );
  }


}
