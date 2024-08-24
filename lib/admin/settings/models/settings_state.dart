// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:avahan/core/models/master_data.dart';

class AdminSettingsState {
  final bool loading;
  final MasterData masterData;
  
  AdminSettingsState({
    required this.loading,
    required this.masterData,
  });

  AdminSettingsState copyWith({
    bool? loading,
    MasterData? masterData,
  }) {
    return AdminSettingsState(
      loading: loading ?? this.loading,
      masterData: masterData ?? this.masterData,
    );
  }
}
