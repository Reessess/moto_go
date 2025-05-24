import 'package:flutter/material.dart';
import 'package:moto_go/Model/booking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

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
    // Generate reference number once when screen opens
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
        Uri.parse('http://192.168.5.129:3000/api/payments'), // Replace with your backend URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful!')),
        );
        Navigator.pop(context);
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Total: ₱${booking.totalCost.toStringAsFixed(2)}'),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _method,
                items: ['GCash', 'PayMaya', 'Bank'].map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) => setState(() => _method = value!),
                decoration: const InputDecoration(labelText: 'Payment Method'),
              ),

              TextFormField(
                controller: _accountNameController,
                decoration: const InputDecoration(labelText: 'Account Name'),
                validator: (value) => value!.isEmpty ? 'Enter account name' : null,
              ),
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(labelText: 'Account Number'),
                validator: (value) => value!.isEmpty ? 'Enter account number' : null,
              ),

              const SizedBox(height: 20),

              Text(
                'Reference Number:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText(_generatedReference), // user can copy it if needed

              const SizedBox(height: 20),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Submit Payment'),
                onPressed: _submitPayment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
