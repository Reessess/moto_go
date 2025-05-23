import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:moto_go/Model/booking.dart'; // Adjust path if needed

class BookingScreen extends StatefulWidget {
  final int bikeId;
  final int userId;
  final double pricePerHour; // Needed to compute total cost

  const BookingScreen({
    Key? key,
    required this.bikeId,
    required this.userId,
    required this.pricePerHour,
  }) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _pickupDateTime;
  final TextEditingController _hoursController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitBooking() async {
    if (_pickupDateTime == null || _hoursController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select pickup time and duration')),
      );
      return;
    }

    final int hours = int.tryParse(_hoursController.text) ?? 0;
    final double totalCost = hours * widget.pricePerHour;

    final booking = Booking(
      bikeId: widget.bikeId,
      userId: widget.userId,
      pickupDateTime: _pickupDateTime!,
      hours: hours,
      totalCost: totalCost,
    );

    setState(() => _isSubmitting = true);

    final response = await http.post(
      Uri.parse('http://192.168.5.129:3000/api/bookings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(booking.toJson()),
    );

    setState(() => _isSubmitting = false);

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking Successful')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book: ${response.body}')),
      );
    }
  }

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
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

  @override
  Widget build(BuildContext context) {
    final formattedDate = _pickupDateTime != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(_pickupDateTime!)
        : 'Select pickup date & time';

    return Scaffold(
      appBar: AppBar(title: Text('Book a Bike')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Pickup Date & Time'),
              subtitle: Text(formattedDate),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDateTime,
            ),
            TextField(
              controller: _hoursController,
              decoration: InputDecoration(labelText: 'Number of Hours'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            if (_hoursController.text.isNotEmpty && _pickupDateTime != null)
              Text(
                'Total Cost: ₱${(int.tryParse(_hoursController.text) ?? 0) * widget.pricePerHour}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitBooking,
              child: _isSubmitting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
