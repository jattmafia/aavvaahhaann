import 'package:avahan/features/dashboard/model/dashboard_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'dashboard_provider.g.dart';

@riverpod
class DashboardNotifier extends _$DashboardNotifier {
  @override
  DashboardState build() {
    return DashboardState(
      index: 0,
    );
  }


  void setIndex(int v) {
    state = state.copyWith(
      index: v,
    );
  }

  void setData(dynamic v){
    state = state.copyWith(
      data: v,
      clearData: v == null,
    );
  }


}
