import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orre/model/store_list_model.dart';
import 'package:orre/provider/home_screen/store_list_sort_type_provider.dart';
import 'package:orre/services/network/https_services.dart';

class StoreListParameters {
  StoreListSortType sortType;
  double latitude;
  double longitude;
  StoreListParameters(
      {required this.sortType,
      required this.latitude,
      required this.longitude});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StoreListParameters &&
        other.sortType == sortType &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(sortType, latitude, longitude);
}

final storeListProvider =
    StateNotifierProvider<StoreListNotifier, List<StoreLocationInfo>>((ref) {
  return StoreListNotifier();
});

class StoreListNotifier extends StateNotifier<List<StoreLocationInfo>> {
  StoreListNotifier() : super([]);
  final paramsMap = Map<StoreListParameters, List<StoreLocationInfo>>();

  Future<List<StoreLocationInfo>> fetchStoreDetailInfo(
      StoreListParameters params) async {
    try {
      if (paramsMap.containsKey(params)) {
        print(
            "Already requested!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        state = paramsMap[params]!;
        return state;
      } else {
        String sortType = params.sortType.toEn();
        double latitude = params.latitude;
        double longitude = params.longitude;
        print("sortType: $sortType");
        print("latitude: $latitude, longitude: $longitude");

        final baseUrl = dotenv.get('ORRE_HTTPS_ENDPOINT_STORELIST') + sortType;
        final body = {
          'latitude': latitude,
          'longitude': longitude,
        };
        final url = '$baseUrl?latitude=$latitude&longitude=$longitude';

        final jsonBody = json.encode(body);
        print('jsonBody: $jsonBody');

        final response = await HttpsService.getRequest(url);

        if (response.statusCode == 200) {
          final jsonBody = json.decode(utf8.decode(response.bodyBytes));
          print('jsonBody: $jsonBody');
          final result = (jsonBody as List)
              .map((e) => StoreLocationInfo.fromJson(e))
              .toList();
          paramsMap.clear();
          print('result: $result');
          paramsMap.addEntries([MapEntry(params, result)]);
          print(
              "paramsMap: $paramsMap!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
          state = result;
          return state;
        } else {
          print('response.statusCode: ${response.statusCode}');
          paramsMap.clear();
          paramsMap.addEntries([MapEntry(params, [])]);
          state = [];
          throw Exception('Failed to fetch store info');
        }
      }
    } catch (error) {
      state = [];
      throw Exception('Failed to fetch store info');
    }
  }

  bool isExistRequest(StoreListParameters params) {
    return paramsMap.containsKey(params);
  }

  void clearRequest() {
    paramsMap.clear();
  }
}
