import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/banner_click.dart';
import 'package:avahan/core/models/banner_stats.dart';
import 'package:avahan/core/models/master_data.dart';
import 'package:avahan/core/models/pages_data.dart';
import 'package:avahan/core/repositories/storage_repository.dart';
import 'package:avahan/features/profile/providers/your_profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../providers/client_provider.dart';

final masterDataRepositoryProvider = Provider(MasterDataRepository.new);

class MasterDataRepository {
  final Ref _ref;

  MasterDataRepository(this._ref);

  supabase.SupabaseClient get _client => _ref.read(clientProvider);

  StorageRepository get _storage => _ref.read(storageRepositoryProvider);

  Future<MasterData> getMasterData() async {
    try {
      final result =
          await _client.from('masterdata').select("*").eq('id', 1).single();

      return MasterData.fromMap(result);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updateMasterData(
    MasterData masterData,
  ) async {
    try {
      final banners = masterData.banners;

      final lenderFutures = banners.map((banner) async {
        if (banner.file != null) {
          final url = await _storage.upload(
            'settings',
            banner.file!,
          );
          banner = banner.copyWith(image: url);
        }

        if (banner.fileHi != null) {
          final url = await _storage.upload(
            'settings',
            banner.fileHi!,
          );
          banner = banner.copyWith(imageHi: url);
        }
        return banner;
      }).toList();

      final updatedLenderBanners = await Future.wait(lenderFutures);
      masterData = masterData.copyWith(banners: updatedLenderBanners);

      await _client.from('masterdata').update(masterData.toMap()).eq('id', 1);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<void> updatePagesData(
    PagesData pagesData,
  ) async {
    try {
      await _client
          .from('pages_data')
          .update(
            pagesData.toMap(),
          )
          .eq('id', 1);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<PagesData> getPagesData() async {
    try {
      final result =
          await _client.from('pages_data').select("*").eq('id', 1).single();

      return PagesData.fromMap(result);
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  void createBannerClickEvent(String bannerId) async {
    print('createBannerClickEvent');
    try {
      final profile = _ref.read(yourProfileProvider).asData?.value;
      final bannerClick = BannerClick(
        bannerId: bannerId,
        userId: profile?.id,
        age: profile?.age,
        city: profile?.city,
        country: profile?.country,
        gender: profile?.gender.name,
        state: profile?.state,
        channel: defaultTargetPlatform.name,
      );
      await _client.from('banner_clicks').insert(bannerClick.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, BannerStats>> getBannerStats(
      List<String> bannerIds) async {
    try {
      final  result = await _client.rpc('get_banner_stats', params: {
        'banner_ids': bannerIds,
      });

      final data = result as Map<String, dynamic>;

      print('data: $data');

      final bannerStats =
          data.map((key, value) => MapEntry(key, BannerStats.fromMap(value)));
      
            print('data: $data');

      return bannerStats;
    }  catch (e) {
      return Future.error(e);
    }
  }
}


// [
//   {
//     "get_banner_stats": {
//       "014e2900-ef94-1067-b53f-13b83b5a5faf": {
//         "today": 1,
//         "total": 1,
//         "last7Days": 1,
//         "thisMonth": 1,
//         "last30Days": 1
//       },
//       "014e2901-ef94-1067-b53f-13b83b5a5faf": {
//         "today": 2,
//         "total": 2,
//         "last7Days": 2,
//         "thisMonth": 2,
//         "last30Days": 2
//       }
//     }
//   }
// ]