import 'package:flutter/material.dart';
import 'package:moto_go/providers/booking_provider.dart'; // Adjust the import path as necessary
import 'package:provider/provider.dart';

class RideHistoryScreen extends StatefulWidget {
  final int userId; // Pass the user ID to the screen

  const RideHistoryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _RideHistoryScreenState createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch bookings for the user when the screen is initialized
    context.read<BookingProvider>().fetchBookings(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingProvider>().bookings;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ride History'),
      ),
      body: bookings.isEmpty
          ? Center(
        child: Text(
          'No ride history found.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return ListTile(
            leading: Icon(Icons.motorcycle),
            title: Text('${booking.bikeBrand} ${booking.bikeModel}'),
            subtitle: Text(
              'Date: ${booking.pickupDateTime.toLocal().toString().split(" ")[0]}',
            ),
            trailing: Text(
              'Hours: ${booking.hours}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}