import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:moto_go/providers/booking_provider.dart';
import 'package:moto_go/providers/user_provider.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late Future<void> _fetchBookingsFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = int.tryParse(userProvider.userId ?? '');
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    if (userId != null) {
      _fetchBookingsFuture = bookingProvider.fetchBookings(userId);
    } else {
      _fetchBookingsFuture = Future.value();
    }
  }

  Future<void> _refreshBookings() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = int.tryParse(userProvider.userId ?? '');
    if (userId != null) {
      await Provider.of<BookingProvider>(context, listen: false).fetchBookings(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userId = int.tryParse(userProvider.userId ?? '');

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Bookings')),
        body: const Center(child: Text('User is not logged in')),
      );
    }

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: FutureBuilder<void>(
        future: _fetchBookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<BookingProvider>(
              builder: (context, bookingProvider, child) {
                if (bookingProvider.bookings.isEmpty) {
                  return const Center(child: Text('No bookings found.'));
                }

                return RefreshIndicator(
                  onRefresh: _refreshBookings,
                  child: ListView.builder(
                    itemCount: bookingProvider.bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookingProvider.bookings[index];
                      final formattedDate = DateFormat('yyyy-MM-dd hh:mm a').format(booking.pickupDateTime);

                      Color getStatusColor(String status) {
                        switch (status.toLowerCase()) {
                          case 'pending':
                            return Colors.orange;
                          case 'paid':
                            return Colors.green;
                          case 'failed':
                            return Colors.red;
                          default:
                            return Colors.grey;
                        }
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${booking.bikeBrand} ${booking.bikeModel}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Pickup: $formattedDate',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Hours: ${booking.hours}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Status: ${booking.status != null && booking.status.isNotEmpty ? booking.status[0].toUpperCase() + booking.status.substring(1) : "Unknown"}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: booking.status != null ? getStatusColor(booking.status) : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total: ₱${booking.totalCost.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Cancel Booking'),
                                          content: const Text('Are you sure you want to cancel this booking?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(ctx).pop(false),
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(ctx).pop(true),
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        try {
                                          await Provider.of<BookingProvider>(context, listen: false)
                                              .cancelBooking(booking.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Booking cancelled')),
                                          );
                                          await _refreshBookings();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Error: $e')),
                                          );
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.cancel, color: Colors.white),
                                    label: const Text('Cancel'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final result = await Navigator.pushNamed(
                                        context,
                                        '/payment',
                                        arguments: booking,
                                      );

                                      if (result == true) {
                                        await bookingProvider.fetchBookings(userId); // refresh booking list
                                      }
                                    },
                                    icon: const Icon(Icons.payment),
                                    label: const Text('Make Payment'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
