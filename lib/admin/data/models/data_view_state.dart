// ignore_for_file: public_member_api_docs, sort_constructors_first



import 'package:avahan/admin/dashboard/enums/view.dart';

class DataViewState {
  final AdminView view;
  final bool write;
  final List<dynamic> list;

  dynamic get selected => list.lastOrNull;


  DataViewState({
    required this.view,
    required this.write,
    required this.list,
  });

  DataViewState copyWith({
    AdminView? view,
    bool? write,
    List<dynamic>? list,
  }) {
    return DataViewState(
      view: view ?? this.view,
      write: write ?? this.write,
      list: list ?? this.list,
    );
  }
}
