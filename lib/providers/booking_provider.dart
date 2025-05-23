import 'package:flutter/material.dart';
import 'package:moto_go/Model/booking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;

  final String apiUrl = 'http://192.168.5.129:3000/api/bookings'; // Your API endpoint

  // Add a booking by posting to backend
  Future<bool> addBooking(Booking booking) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(booking.toJson()),
      );

      if (response.statusCode == 201) {
        // Optionally add the new booking locally (you can parse the returned booking if needed)
        // final newBooking = Booking.fromJson(json.decode(response.body));
        // _bookings.add(newBooking);

        notifyListeners();
        return true;
      } else {
        print('Failed to add booking: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding booking: $e');
      return false;
    }
  }

  // Optional: fetch bookings from backend
  Future<void> fetchBookings() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _bookings = data.map((json) => Booking.fromJson(json)).toList();
        notifyListeners();
      } else {
        print('Failed to fetch bookings');
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }
}
