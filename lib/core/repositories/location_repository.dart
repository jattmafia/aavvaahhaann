import 'dart:developer';

import 'package:avahan/config.dart';
import 'package:avahan/core/extensions.dart';
import 'package:avahan/core/models/loc_obj.dart';
import 'package:avahan/core/models/location.dart';
import 'package:avahan/core/providers/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final locationRepositoryProvider = Provider.autoDispose(LocationRepository.new);

class LocationRepository {
  final Ref _ref;

  LocationRepository(this._ref);

  Dio get _dio => _ref.read(dioProvider);

  Future<Location> getLocation() async {
    
    try {
      final res = await _dio.get("https://location.avahan.app/");
       
      final data = res.data as Map<String, dynamic>;
      return Location.fromMap(data["data"]);
    } on Exception catch (e) {
     
      return Future.error(e.parse);
    }
  }

  Future<List<LocObj>> getCountries() async {
    try {
      final res = await _dio.get(
        "https://api.countrystatecity.in/v1/countries",
        options: Options(headers: {'X-CSCAPI-KEY': Config.cscApiKey}),
      );
      final data = res.data as List<dynamic>;
      return data.map((e) => LocObj.fromMap(e)).toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<List<LocObj>> getStates(String ciso) async {
    try {
      final res = await _dio.get(
        "https://api.countrystatecity.in/v1/countries/$ciso/states",
        options: Options(headers: {'X-CSCAPI-KEY': Config.cscApiKey}),
      );
      final data = res.data as List<dynamic>;
      return data.map((e) => LocObj.fromMap(e)).toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }

  Future<List<String>> getCities(String ciso, String siso) async {
    try {
      final res = await _dio.get(
        "https://api.countrystatecity.in/v1/countries/$ciso/states/$siso/cities",
        options: Options(headers: {'X-CSCAPI-KEY': Config.cscApiKey}),
      );
      final data = res.data as List<dynamic>;
      return data.map((e) => e["name"] as String).toList();
    } on Exception catch (e) {
      return Future.error(e.parse);
    }
  }
}
