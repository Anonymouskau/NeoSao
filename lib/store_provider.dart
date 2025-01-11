import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Store {
  final String code;
  final String storeLocation;
  final double latitude;
  final double longitude;
  final String storeAddress;

  Store({
    required this.code,
    required this.storeLocation,
    required this.latitude,
    required this.longitude,
    required this.storeAddress,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      code: json['code'],
      storeLocation: json['storeLocation'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      storeAddress: json['storeAddress'],
    );
  }
}

class StoreProvider with ChangeNotifier {
  List<Store> _stores = [];
  List<Marker> _markers = [];
  bool _isLoading = false;

  List<Store> get stores => _stores;
  List<Marker> get markers => _markers;
  bool get isLoading => _isLoading;

  Future<void> fetchStores() async {
    const String apiUrl = "https://atomicbrain.neosao.online/nearest-store";
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['msg'] == 'success') {
          List<dynamic> storeData = jsonResponse['data'];
          _stores = storeData.map((json) => Store.fromJson(json)).toList();

          _markers = _stores.map((store) {
            return Marker(
              markerId: MarkerId(store.code),
              position: LatLng(store.latitude, store.longitude),
              infoWindow: InfoWindow(
                title: store.storeLocation,
                snippet: store.storeAddress,
              ),
            );
          }).toList();
        }
      }
    } catch (e) {
      print("Error fetching store data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectStore(Store store, GoogleMapController mapController) {
    mapController.animateCamera(
      CameraUpdate.newLatLng(LatLng(store.latitude, store.longitude)),
    );
  }
}
