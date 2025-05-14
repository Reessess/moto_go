import 'package:flutter/material.dart';
import 'login_screen.dart';  // Make sure to import your login screen

class OtpInputScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpInputScreen({super.key, required this.phoneNumber});

  @override
  State<OtpInputScreen> createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  final TextEditingController otpController = TextEditingController();
  int _remainingTime = 60; // 1 minute countdown
  bool _isOtpValid = false;
  bool _isResendEnabled = false; // Initially disabled

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  // Countdown timer logic
  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
          _isResendEnabled = false;
        });
        _startCountdown(); // Recurse to update every second
      } else {
        setState(() {
          _isResendEnabled = true;
        });
      }
    });
  }

  // Simulated function to resend OTP
  void resendOTP() {
    setState(() {
      _remainingTime = 60; // Reset the timer to 1 minute
      _isResendEnabled = false; // Disable the button again
    });
    _startCountdown(); // Restart the countdown
    // Here, you can make an API call to resend the OTP
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP Resent! Please check your phone.')),
    );
  }

  void validateAndSubmitOtp() {
    final otp = otpController.text.trim();
    final isOtpValid = RegExp(r'^\d{6}$').hasMatch(otp);

    if (!isOtpValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid 6-digit OTP')),
      );
      return;
    }

    // Proceed with OTP verification
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP Submitted')),
    );

    // Show dialog with option to go to login screen after verification
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('OTP Verified'),
          content: const Text('Your OTP has been successfully verified.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),  // Navigate to LoginScreen
                );
              },
              child: const Text('Go to Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Abstract shapes
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
                    'We have sent a one-time password to:',
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
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: 'Enter OTP',
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
                        onPressed: validateAndSubmitOtp,
                        child: const Text(
                          'Verify',
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
                      onPressed: _isResendEnabled ? resendOTP : null,  // Enable only when countdown ends
                      child: Text(
                        _isResendEnabled
                            ? 'Resend OTP'
                            : 'Wait for ${_remainingTime}s',
                        style: const TextStyle(
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
