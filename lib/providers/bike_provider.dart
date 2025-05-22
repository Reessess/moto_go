import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moto_go/Model/bike.dart';

class BikeProvider with ChangeNotifier {
  List<Bike> _bikes = [];
  List<Bike> get bikes => _bikes;

  Future<void> fetchBikes({String brand = '', double? maxPrice}) async {
    final uri = Uri.parse('http://YOUR_SERVER_IP:PORT/api/bikes');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      _bikes = data.map((item) => Bike.fromJson(item)).toList();

      // Optional filtering
      if (brand.isNotEmpty) {
        _bikes = _bikes.where((b) => b.brand.toLowerCase() == brand.toLowerCase()).toList();
      }
      if (maxPrice != null) {
        _bikes = _bikes.where((b) => b.pricePerDay <= maxPrice).toList();
      }

      notifyListeners();
    } else {
      throw Exception('Failed to load bikes');
    }
  }
}
