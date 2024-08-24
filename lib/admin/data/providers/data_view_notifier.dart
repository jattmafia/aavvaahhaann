import 'package:avahan/admin/dashboard/enums/view.dart';
import 'package:avahan/admin/data/models/data_view_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_view_notifier.g.dart';

@Riverpod(keepAlive: true)
class DataView extends _$DataView {
  @override
  DataViewState build() {
    return DataViewState(view: AdminView.categories, write: false, list: []);
  }

  void viewChanged(AdminView value) async {
    state = DataViewState(
      view: value,
      write: false,
      list: [],
    );
  }

  void closeWrite() async {
    state = state.copyWith(
      write: false,
    );
  }

  void showWrite([dynamic value]) async {
    state = state.copyWith(write: true, list: value != null? [
      ...state.list.sublist(0, state.list.length - 1),
      value,
    ]: null);
  }

  void show(dynamic value) {
    state = DataViewState(view: state.view, write: state.write, list: [
      ...(value != null
          ? state.list
          : state.list.sublist(0, state.list.length - 1)),
      if (value != null) value
    ]);
  }
}
