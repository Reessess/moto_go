import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:moto_go/Model/bike.dart';
import 'package:moto_go/providers/user_provider.dart';

class BookingScreen extends StatefulWidget {
  final Bikes selectedBike;

  const BookingScreen({Key? key, required this.selectedBike}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _pickupDateTime;
  final TextEditingController _hoursController = TextEditingController();

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
    final int? userId = int.tryParse(userProvider.userId ?? '');
    final int? bikeId = int.tryParse(widget.selectedBike.id.toString());

    if (userId == null) {
      _showMessage('User is not logged in');
      return;
    }
    if (bikeId == null) {
      _showMessage('Invalid bike selected');
      return;
    }

    final int hours = int.tryParse(_hoursController.text) ?? 0;
    if (_pickupDateTime == null || hours <= 0) {
      _showMessage('Please enter valid pickup time and hours');
      return;
    }

    final double totalCost = hours * widget.selectedBike.pricePerHour;

    final bookingData = {
      "bike_id": bikeId,
      "user_id": userId,
      "pickup_datetime": _pickupDateTime!.toIso8601String(),
      "hours": hours,
      "total_cost": totalCost,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.5.129:3000/api/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookingData),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showMessage('Booking successful');
        Navigator.pop(context);
      } else {
        _showMessage('Booking failed: ${data['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      _showMessage('Error: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bike = widget.selectedBike;
    final userProvider = Provider.of<UserProvider>(context);
    final String formattedDate = _pickupDateTime != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(_pickupDateTime!)
        : 'Select pickup date & time';

    final int hours = int.tryParse(_hoursController.text) ?? 0;
    final double totalCost = hours * bike.pricePerHour;
    final bool canSubmit = _pickupDateTime != null && hours > 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Book a Bike')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoCard(
              icon: Icons.person,
              title: userProvider.username ?? 'Guest User',
              subtitle: userProvider.email ?? 'No Email',
            ),
            _buildInfoCard(
              icon: Icons.directions_bike,
              title: '${bike.brand} ${bike.model}',
              subtitle: 'Price per hour: ₱${bike.pricePerHour.toStringAsFixed(2)}',
            ),
            _buildDateTimeTile(formattedDate),
            const SizedBox(height: 12),
            TextField(
              controller: _hoursController,
              decoration: const InputDecoration(
                labelText: 'Number of Hours',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            if (canSubmit)
              Text(
                'Total Cost: ₱${totalCost.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSubmit ? _submitBooking : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String subtitle}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildDateTimeTile(String formattedDate) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: const Text('Pickup Date & Time'),
        subtitle: Text(formattedDate),
        trailing: const Icon(Icons.calendar_today),
        onTap: _pickDateTime,
      ),
    );
  }
}
