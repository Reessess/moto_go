import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moto_go/Model/bike.dart';

import 'package:moto_go/providers/user_provider.dart';
import 'package:moto_go/providers/bike_provider.dart';

class BookingScreen extends StatefulWidget {
  final Bikes selectedBike;

  const BookingScreen({Key? key, required this.selectedBike}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _pickupDateTime;
  final TextEditingController _hoursController = TextEditingController();
  bool _isSubmitting = false;

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time == null) return;

    setState(() {
      _pickupDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submitBooking() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // userId as int? converted from string stored in UserProvider
    final String? userIdStr = userProvider.userId;
    final int? userId = userIdStr != null ? int.tryParse(userIdStr) : null;

    final Bikes bike = widget.selectedBike;
    final int? bikeId = int.tryParse(bike.id);
    final double pricePerHour = bike.pricePerHour;

    if (userId == null || bikeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing user or bike data')),
      );
      return;
    }

    final int hours = int.tryParse(_hoursController.text) ?? 0;
    if (_pickupDateTime == null || hours <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid pickup time and hours')),
      );
      return;
    }

    final double totalCost = hours * pricePerHour;

    final bookingData = {
      "bike_id": bikeId,
      "user_id": userId,
      "pickup_datetime": _pickupDateTime!.toIso8601String(),
      "hours": hours,
      "total_cost": totalCost,
    };

    setState(() => _isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.5.129:3000/api/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookingData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking successful')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bike = widget.selectedBike;
    final pricePerHour = bike.pricePerHour;

    final String formattedDate = _pickupDateTime != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(_pickupDateTime!)
        : 'Select pickup date & time';

    final int hours = int.tryParse(_hoursController.text) ?? 0;
    final double totalCost = hours * pricePerHour;

    return Scaffold(
      appBar: AppBar(title: const Text('Book a Bike')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Pickup Date & Time'),
              subtitle: Text(formattedDate),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDateTime,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _hoursController,
              decoration: const InputDecoration(
                labelText: 'Number of Hours',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            if (hours > 0 && _pickupDateTime != null)
              Text(
                'Total Cost: ₱${totalCost.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitBooking,
                child: _isSubmitting
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
