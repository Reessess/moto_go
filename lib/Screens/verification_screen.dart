import 'package:flutter/material.dart';
import 'OtpInputScreen.dart';
import 'EmailInputScreen.dart';

class Verification1Widget extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  Verification1Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Decorative background shapes
          Positioned(
            top: -60,
            left: -40,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 200,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: const Color(0xFF1E3229),
                ),
              ),
            ),
          ),
          Positioned(
            top: -50,
            right: -30,
            child: Transform.rotate(
              angle: 0.3,
              child: Container(
                width: 180,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFF1D2C69),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -30,
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 220,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFC7B423),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 250,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF691D1D),
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OTP Verification',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Inter',
                      color: Color(0xFFBF6A20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Enter your phone number to receive a one-time password:',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                      color: Color(0xFFBF6A20),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: const TextStyle(color: Color(0xFFBF6A20)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBF6A20), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black, width: 1.6),
                      ),
                      filled: true,
                      fillColor: const Color.fromRGBO(217, 217, 217, 1),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      width: 220,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        color: const Color(0xFF1D2C69),
                      ),
                      child: TextButton(
                        onPressed: () {
                          final phone = phoneController.text.trim();
                          final isValid = RegExp(r'^\d{11}$').hasMatch(phone);

                          if (!isValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Phone number must be exactly 11 digits.'),
                              ),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpInputScreen(phoneNumber: phone),
                            ),
                          );

                          phoneController.clear(); // ✅ Clear after navigation
                        },
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Inter',
                            color: Color(0xFFBF6A20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        final phone = phoneController.text.trim();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailInputScreen(phoneNumber: phone),
                          ),
                        );

                        phoneController.clear(); // ✅ Clear after navigation
                      },
                      child: const Text(
                        'Use Email?',
                        style: TextStyle(
                          color: Color(0xFFBF6A20),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
