import 'package:flutter/material.dart';
import 'package:moto_go/Model/booking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import  'package:moto_go/providers/booking_provider.dart';
import 'package:moto_go/providers/user_provider.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final Booking booking;
  const PaymentScreen({Key? key, required this.booking}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _method = 'GCash';
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  bool _isLoading = false;

  final _uuid = Uuid();
  late final String _generatedReference;

  Booking get booking => widget.booking;

  @override
  void initState() {
    super.initState();
    _generatedReference = _uuid.v4();
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final payload = {
      'bookingId': booking.id,
      'userId': booking.userId,
      'method': _method,
      'accountName': _accountNameController.text,
      'accountNumber': _accountNumberController.text,
      'referenceNumber': _generatedReference,
      'amount': booking.totalCost,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.5.129:3000/api/payments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful!')),
        );

        final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final userId = int.tryParse(userProvider.userId ?? '');
        if (userId != null) {
          await bookingProvider.fetchBookings(userId);
        }

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                '${booking.bikeBrand} ${booking.bikeModel}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Total: ₱${booking.totalCost.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _method,
                items: ['GCash', 'PayMaya', 'Bank'].map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) => setState(() => _method = value!),
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _accountNameController,
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Enter account name' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Enter account number' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              Text(
                'Reference Number:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SelectableText(_generatedReference),
              const SizedBox(height: 20),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Payment'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _submitPayment,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
