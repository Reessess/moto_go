import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moto_go/Model/booking.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;

  Future<void> fetchBookings(int userId) async {
    final url = Uri.parse('http://192.168.5.129:3000/api/bookings/$userId'); // ✅ fixed URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _bookings = data.map((json) => Booking.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load bookings (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }
}
