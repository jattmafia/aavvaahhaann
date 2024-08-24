import 'package:avahan/core/models/pages_data.dart';

class AdminPagesState {
  final bool loading;
  final PagesData pagesData;

  AdminPagesState({
    required this.loading,
    required this.pagesData,
  });

  AdminPagesState copyWith({
    bool? loading,
    PagesData? pagesData,
  }) {
    return AdminPagesState(
      loading: loading ?? this.loading,
      pagesData: pagesData ?? this.pagesData,
    );
  }
}
