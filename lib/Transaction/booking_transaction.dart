import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moto_go/Transaction/booking_manager.dart';
import 'package:moto_go/Transaction/my_bookings_screen.dart';

class BookingTransactionScreen extends StatefulWidget {
  final Map<String, dynamic> bike;

  const BookingTransactionScreen({super.key, required this.bike});

  @override
  State<BookingTransactionScreen> createState() =>
      _BookingTransactionScreenState();
}

class _BookingTransactionScreenState extends State<BookingTransactionScreen> {
  int _rentalHours = 1;
  DateTime? _pickupDate;

  // Static list to simulate storing confirmed bookings
  static List<Map<String, dynamic>> confirmedBookings = [];

  Future<void> _selectPickupDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _pickupDate = picked;
      });
    }
  }

  void _confirmBooking() {
    if (_pickupDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a pickup date'),
        ),
      );
      return;
    }

    // Add booking info to static list
    BookingManager.addBooking({
      'bike': widget.bike,
      'rentalHours': _rentalHours,
      'pickupDate': _pickupDate,
      'bookingTime': DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking confirmed!')),
    );

    // Optionally reset or navigate
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bike = widget.bike;
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'My Bookings',
            onPressed: () {
              Navigator.pushNamed(context, '/myBookings');
            },
          )
        ],
      ),
      body: Stack(
        children: [
          // Abstract map-like background behind everything
          const CustomPaint(
            size: Size.infinite,
            painter: MapShapePainter(),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          bike['image'],
                          height: media.height * 0.22,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      bike['label'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${bike['price']} / Hour',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'How many hours to rent?',
                            style: TextStyle(fontSize: 17),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle,
                                    color: Colors.orange),
                                onPressed: () {
                                  if (_rentalHours > 1) {
                                    setState(() {
                                      _rentalHours--;
                                    });
                                  }
                                },
                              ),
                              Text(
                                '$_rentalHours Hour${_rentalHours > 1 ? 's' : ''}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle,
                                    color: Colors.orange),
                                onPressed: () {
                                  setState(() {
                                    _rentalHours++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Pick-up Date',
                            style: TextStyle(fontSize: 17),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _selectPickupDate,
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              _pickupDate == null
                                  ? 'Select Date'
                                  : DateFormat('yyyy-MM-dd').format(_pickupDate!),
                              style: const TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _confirmBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirm Booking',
                          style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}

/// Custom painter for the colorful abstract map-like background shape.
class MapShapePainter extends CustomPainter {
  const MapShapePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // First abstract shape (top-left, soft blue)
    Path path1 = Path();
    path1.moveTo(0, size.height * 0.35);
    path1.quadraticBezierTo(
        size.width * 0.25, size.height * 0.2, size.width * 0.45, size.height * 0.4);
    path1.quadraticBezierTo(
        size.width * 0.3, size.height * 0.65, 0, size.height * 0.65);
    path1.close();
    paint.color = Colors.blue.withOpacity(0.3);
    canvas.drawPath(path1, paint);

    // Second abstract shape (center-right, soft green)
    Path path2 = Path();
    path2.moveTo(size.width * 0.55, size.height * 0.1);
    path2.quadraticBezierTo(size.width * 0.85, size.height * 0.05,
        size.width, size.height * 0.25);
    path2.quadraticBezierTo(
        size.width * 0.7, size.height * 0.55, size.width * 0.55, size.height * 0.5);
    path2.close();
    paint.color = Colors.green.withOpacity(0.35);
    canvas.drawPath(path2, paint);

    // Third abstract shape (bottom-left, soft orange)
    Path path3 = Path();
    path3.moveTo(0, size.height * 0.8);
    path3.quadraticBezierTo(
        size.width * 0.15, size.height * 0.7, size.width * 0.3, size.height * 0.95);
    path3.lineTo(0, size.height);
    path3.close();
    paint.color = Colors.orange.withOpacity(0.3);
    canvas.drawPath(path3, paint);

    // Fourth abstract shape (bottom-right, soft purple)
    Path path4 = Path();
    path4.moveTo(size.width * 0.7, size.height);
    path4.quadraticBezierTo(
        size.width * 0.85, size.height * 0.85, size.width, size.height * 0.9);
    path4.lineTo(size.width, size.height);
    path4.close();
    paint.color = Colors.purple.withOpacity(0.25);
    canvas.drawPath(path4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
