import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Bike {
  final String id;
  final String brand;
  final String model;
  final String imageUrl;
  final double pricePerHour;
  final String status;

  Bike({
    required this.id,
    required this.brand,
    required this.model,
    required this.imageUrl,
    required this.pricePerHour,
    required this.status,
  });

  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      id: json['id'].toString(),
      brand: json['brand'],
      model: json['model'],
      imageUrl: json['imageUrl'],
      pricePerHour: double.tryParse(json['pricePerHour'].toString()) ?? 0.0,
      status: json['status'],
    );
  }
}

class BikeProvider with ChangeNotifier {
  List<Bike> _bikes = [];

  List<Bike> get bikes => [..._bikes];

  Future<void> fetchBikes({
    String? brand,
    String? model,
    double? maxPricePerHour,
  }) async {
    final String baseUrl = 'http://192.168.5.129:3000/api/bikes';

    final Map<String, String> queryParams = {};
    if (brand != null && brand.isNotEmpty) {
      queryParams['brand'] = brand;
    }
    if (model != null && model.isNotEmpty) {
      queryParams['model'] = model;
    }
    if (maxPricePerHour != null) {
      queryParams['pricePerHour'] = maxPricePerHour.toString();
    }

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _bikes = data.map((jsonBike) => Bike.fromJson(jsonBike)).toList();
        notifyListeners();
      } else {
        print('Failed to load bikes. Status code: ${response.statusCode}');
        _bikes = [];
        notifyListeners();
      }
    } catch (error) {
      print('Error fetching bikes: $error');
      _bikes = [];
      notifyListeners();
    }
  }
}
