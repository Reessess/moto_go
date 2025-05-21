import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> bike;

  const BookingScreen({super.key, required this.bike});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int rentalHours = 1;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final bike = widget.bike;
    final pricePerHour = bike['price'] as int;
    final total = pricePerHour * rentalHours;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bike Rental'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bike image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                bike['image'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Bike label
            Text(
              bike['label'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'nunito',
              ),
            ),
            const SizedBox(height: 8),

            // Stylish Specs Card
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "⚙️ Specs",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• Engine: 155cc",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  Text(
                    "• Top Speed: 130 km/h",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  Text(
                    "• Fuel Efficiency: 40 km/l",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),

            const Text(
              '🟢 Available',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),

            const SizedBox(height: 20),

            // Rental duration picker with rounded container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Duration (in hours):',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: rentalHours > 1
                            ? () => setState(() => rentalHours--)
                            : null,
                      ),
                      Text(
                        '$rentalHours',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => rentalHours++),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Pickup Date picker with rounded container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pickup Date:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text(
                      _selectedDate != null
                          ? DateFormat('MMMM d, y').format(_selectedDate!)
                          : 'Choose Date',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            // Pickup Time picker with rounded container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pickup Time:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: _pickTime,
                    child: Text(
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : 'Choose Time',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            // Total price
            Text(
              'Total: ₱$total',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 24),

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payment),
                label: const Text('Select Payment Method'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  if (_selectedDate == null || _selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select both date and time.'),
                      ),
                    );
                    return;
                  }
                  _showPaymentMethodDialog(total);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _showPaymentMethodDialog(int total) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              _buildPaymentOption(
                ctx,
                'GCash',
                'assets/gcash.PNG',
                    () {
                  Navigator.of(ctx).pop();
                  _showConfirmationDialog(context, total, 'GCash');
                },
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                ctx,
                'PayMaya',
                'assets/paymaya.PNG',
                    () {
                  Navigator.of(ctx).pop();
                  _showConfirmationDialog(context, total, 'PayMaya');
                },
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                ctx,
                'Online Banking',
                'assets/bank.PNG', // Put your online banking icon here
                    () {
                  Navigator.of(ctx).pop();
                  _showConfirmationDialog(context, total, 'Online Banking');
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(
      BuildContext context,
      String label,
      String iconPath,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade200),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, int total, String paymentMethod) {
    final pickupDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final formattedDateTime =
    DateFormat('MMMM d, y – h:mm a').format(pickupDateTime);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Booking Confirmed ✅'),
        content: Text(
          'You have successfully booked ${widget.bike['label']} '
              'for $rentalHours hour(s).\n\n'
              'Pickup: $formattedDateTime\n'
              'Total Payment: ₱$total\n'
              'Payment Method: $paymentMethod',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context)
              ..pop()
              ..pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
