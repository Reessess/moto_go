import 'package:flutter/material.dart';
import 'login_screen.dart';  // Import your LoginScreen file

class EmailInputScreen extends StatefulWidget {
  final String phoneNumber;

  const EmailInputScreen({super.key, required this.phoneNumber});

  @override
  _EmailInputScreenState createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isEmailSent = false;  // Track whether the email is sent

  bool _isValidEmail(String email) {
    // Basic regex for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Function to simulate sending an email verification link
  Future<void> _sendVerificationEmail() async {
    // You can replace this with actual email sending logic
    setState(() {
      isEmailSent = true;
    });
    await Future.delayed(const Duration(seconds: 2));  // Simulate network delay
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification email sent!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Abstract rectangle shapes (same as before)
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
                    'Email Verification',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Inter',
                      color: Color(0xFFBF6A20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'We have already sent the verification link to your email:',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                      color: Color(0xFFBF6A20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.phoneNumber,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Inter',
                      color: Color(0xFFBF6A20),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Enter Email',
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
                          final email = emailController.text.trim();
                          if (_isValidEmail(email)) {
                            // Trigger email verification
                            _sendVerificationEmail();
                            // Show dialog after email verification
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Email Verification'),
                                  content: const Text('A verification link has been sent to your email.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => LoginScreen()),
                                        );
                                      },
                                      child: const Text('Go to Login'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a valid email address')),
                            );
                          }
                        },
                        child: const Text(
                          'Verify Email',
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
                        // Resend the verification email logic
                        if (!isEmailSent) {
                          _sendVerificationEmail();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You have already received the verification email')),
                          );
                        }
                      },
                      child: const Text(
                        'Resend Email',
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
