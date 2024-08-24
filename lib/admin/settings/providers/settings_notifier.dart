// ignore_for_file: unused_result

import 'package:avahan/admin/settings/models/settings_state.dart';
import 'package:avahan/core/models/app_banner.dart';
import 'package:avahan/core/models/datetime_slot.dart';
import 'package:avahan/core/models/master_data.dart';
import 'package:avahan/core/providers/master_data_provider.dart';
import 'package:avahan/core/repositories/master_data_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'settings_notifier.g.dart';

@riverpod
class AdminSettingsNotifier extends _$AdminSettingsNotifier {
  @override
  AdminSettingsState build(MasterData masterData) {
    return AdminSettingsState(
      loading: false,
      masterData: masterData,
    );
  }

  bool get savable => masterData != state.masterData;

  void versionChanged(int v) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        version: v,
      ),
    );
  }

  void forceChanged(bool v) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        force: v,
      ),
    );
  }

  void versionIosChanged(int v) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        versionIos: v,
      ),
    );
  }

  void forceIosChanged(bool v) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        forceIos: v,
      ),
    );
  }

  void maintenanceChanged(bool v) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        maintenance: v,
      ),
    );
  }

  void bannersChanged(List<AppBanner> banners) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        banners: banners,
      ),
    );
  }

  void toggleFreeTrailTrack(int id) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        freeTrialTracks: state.masterData.freeTrialTracks.contains(id)
            ? state.masterData.freeTrialTracks
                .where((element) => element != id)
                .toList()
            : [id, ...state.masterData.freeTrialTracks],
      ),
    );
  }

  void toggleDateTimeSlot(DateTimeSlot slot) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        freeSlots: state.masterData.freeSlots.contains(slot)
            ? state.masterData.freeSlots
                .where((element) => element != slot)
                .toList()
            : [
                slot,
                ...state.masterData.freeSlots,
              ],
      ),
    );
  }

  void toggleGroupId(String id) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        groupIds: state.masterData.groupIds.contains(id)
            ? state.masterData.groupIds
                .where((element) => element != id)
                .toList()
            : [
                id,
                ...state.masterData.groupIds,
              ],
      ),
    );
  }

  void freeTrailDaysChanged(int days) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        freeTrailDays: days,
      ),
    );
  }

  void contactPhoneChanged(String phone) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        contactPhone: phone,
      ),
    );
  }

  void contactEmailChanged(String email) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        contactEmail: email,
      ),
    );
  }

  void appShareMessageChanged(String message) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        appShareMessage: message,
      ),
    );
  }

  void termsUrlChanged(String url) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        termsUrl: url,
      ),
    );
  }

  void privacyUrlChanged(String url) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        privacyUrl: url,
      ),
    );
  }

  void aboutEnUrlChanged(String url) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        aboutEnUrl: url,
      ),
    );
  }

  void aboutHiUrlChanged(String url) {
    state = state.copyWith(
      masterData: state.masterData.copyWith(
        aboutHiUrl: url,
      ),
    );
  }

  Future<void> save() async {
    state = state.copyWith(loading: true);
    try {
      await ref.read(masterDataRepositoryProvider).updateMasterData(
            state.masterData.copyWith(
              
              banners: state.masterData.banners
                  .map(
                    (e) => e.copyWith(
                      id: e.id ?? const Uuid().v1(),
                    ),
                  )
                  .toList(),
            ),
          );
      ref.refresh(masterDataProvider);
    } catch (e) {
      state = state.copyWith(loading: false);
      return Future.error(e);
    }
  }
}
