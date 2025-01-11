import 'dart:convert';
import 'package:http/http.dart' as http;

class Store {
  final String code;
  final String storeLocation;
  final double latitude;
  final double longitude;
  final String storeAddress;
  final String timezone;
  final double distance;
  final bool isNearestStore;
  final String dayOfWeek;
  final String startTime;
  final String endTime;

  Store({
    required this.code,
    required this.storeLocation,
    required this.latitude,
    required this.longitude,
    required this.storeAddress,
    required this.timezone,
    required this.distance,
    required this.isNearestStore,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      code: json['code'],
      storeLocation: json['storeLocation'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      storeAddress: json['storeAddress'],
      timezone: json['timezone'],
      distance: json['distance'].toDouble(),
      isNearestStore: json['isNearestStore'] == 1,
      dayOfWeek: json['dayOfWeek'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}

class StoreService {
  static const String apiUrl = "https://atomicbrain.neosao.online/nearest-store";

  Future<List<Store>> fetchStores() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['msg'] == "success") {
        List<dynamic> storeData = jsonResponse['data'];
        
        return storeData.map((store) => Store.fromJson(store)).toList();
      } else {
        throw Exception('Failed to fetch stores: ${jsonResponse['msg']}');
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }
}
