// ignore_for_file: unused_result

import 'package:avahan/admin/settings/models/pages_state.dart';
import 'package:avahan/admin/settings/models/settings_state.dart';
import 'package:avahan/core/enums/lang.dart';
import 'package:avahan/core/models/app_banner.dart';
import 'package:avahan/core/models/datetime_slot.dart';
import 'package:avahan/core/models/master_data.dart';
import 'package:avahan/core/models/pages_data.dart';
import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:avahan/core/providers/pages_data_provider.dart';
import 'package:avahan/core/repositories/master_data_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pages_notifier.g.dart';

@riverpod
class PagesNotifier extends _$PagesNotifier {
  @override
  AdminPagesState build(PagesData pagesData) {
    return AdminPagesState(
      loading: false,
      pagesData: pagesData,
    );
  }

  void tcChanged(String value, Lang lang) {
    state = state = state.copyWith(
      pagesData: state.pagesData.copyWith(
        tcEn: lang == Lang.en ? value : null,
        tcHi: lang == Lang.hi ? value : null,
      ),
    );
  }

  void privacyChanged(String value, Lang lang) {
    state = state = state.copyWith(
      pagesData: state.pagesData.copyWith(
        privacyEn: lang == Lang.en ? value : null,
        privacyHi: lang == Lang.hi ? value : null,
      ),
    );
  }

  void aboutChanged(String value, Lang lang) {
    state = state = state.copyWith(
      pagesData: state.pagesData.copyWith(
        aboutEn: lang == Lang.en ? value : null,
        aboutHi: lang == Lang.hi ? value : null,
      ),
    );
  }

  bool get savable => pagesData != state.pagesData;

  Future<void> save() async {
    state = state.copyWith(loading: true);
    try {
      await ref.read(masterDataRepositoryProvider).updatePagesData(
            state.pagesData,
          );
      ref.refresh(pagesDataProvider);
    } catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e);
    }
  }
}
