import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

import 'login_screen.dart'; // Replace with your actual login screen path

class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({super.key});

  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        repeatPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    if (passwordController.text != repeatPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    String localPhone = phoneController.text.trim();
    String? backendPhone;

    if (localPhone.isEmpty) {
      backendPhone = null;
    } else if (localPhone.startsWith("09") && localPhone.length == 11) {
      backendPhone = "+63" + localPhone.substring(1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid Philippine phone number starting with 09 and 11 digits long',
          ),
        ),
      );
      return;
    }

    final url = Uri.parse('http://192.168.5.129:3000/api/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "first_name": firstNameController.text.trim(),
          "middle_name": middleNameController.text.trim().isEmpty
              ? null
              : middleNameController.text.trim(),
          "last_name": lastNameController.text.trim(),
          "username": usernameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": backendPhone,
          "dob": dobController.text.trim().isEmpty ? null : dobController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        });
      } else {
        String errorMsg = 'Registration failed';
        try {
          final body = jsonDecode(response.body);
          if (body['error'] != null) errorMsg = body['error'];
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isPassword = false,
        TextInputType keyboardType = TextInputType.text,
        int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Material(
        elevation: 2,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(24),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          maxLength: maxLength,
          cursorColor: const Color(0xFFBF6A20),
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: Colors.white,
            labelText: label,
            labelStyle: const TextStyle(
              color: Color(0xFFBF6A20),
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFBF6A20), width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.8),
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          inputFormatters: keyboardType == TextInputType.phone
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
        ),
      ),
    );
  }

  Widget buildDateOfBirthField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Material(
        elevation: 2,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(24),
        child: TextField(
          controller: dobController,
          readOnly: true,
          cursorColor: const Color(0xFFBF6A20),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: 'Date of Birth',
            labelStyle: const TextStyle(
              color: Color(0xFFBF6A20),
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFFBF6A20)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFBF6A20), width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.8),
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2000, 1, 1),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFFBF6A20),
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFBF6A20),
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              String formattedDate =
                  "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
              setState(() {
                dobController.text = formattedDate;
              });
            }
          },
        ),
      ),
    );
  }

  // New widget for abstract map-like background shapes
  Widget buildMapAbstractBackground() {
    return Stack(
      children: [
        // Base background color
        Container(color: Colors.white),

        // Large abstract shape bottom left
        Positioned(
          bottom: -150,
          left: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFB06B1D).withOpacity(0.15),
                  Colors.transparent,
                ],
                center: Alignment.center,
                radius: 0.8,
              ),
            ),
          ),
        ),

        // Layered translucent wavy shapes
        Positioned(
          top: 40,
          right: -80,
          child: Transform.rotate(
            angle: 0.4,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(180),
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFB06B1D).withOpacity(0.12),
                    Colors.transparent,
                  ],
                  radius: 0.7,
                ),
              ),
            ),
          ),
        ),

        // Smaller overlapping circle top left
        Positioned(
          top: 80,
          left: 30,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFB06B1D).withOpacity(0.10),
                  Colors.transparent,
                ],
                radius: 0.8,
              ),
            ),
          ),
        ),

        // Thin curved lines for map-like effect
        Positioned.fill(
          child: CustomPaint(
            painter: MapLinesPainter(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildMapAbstractBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      "REGISTER",
                      style: TextStyle(
                        fontSize: 34,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFBF6A20),
                        letterSpacing: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Create your account",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    buildTextField("First Name", firstNameController),
                    buildTextField("Middle Name (Optional)", middleNameController),
                    buildTextField("Last Name", lastNameController),
                    buildTextField("Username", usernameController),
                    buildTextField("Email Address", emailController,
                        keyboardType: TextInputType.emailAddress),
                    buildTextField("Phone Number (09xxxxxxxxx)",
                        phoneController,
                        keyboardType: TextInputType.phone, maxLength: 11),
                    buildDateOfBirthField(),
                    buildTextField("Password", passwordController,
                        isPassword: true),
                    buildTextField("Repeat Password", repeatPasswordController,
                        isPassword: true),

                    const SizedBox(height: 36),

                    ElevatedButton(
                      onPressed: registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBF6A20),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black45,
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(
                          color: Color(0xFFBF6A20),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
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
    );
  }
}

// Painter to draw subtle thin curved lines for a map-like effect
class MapLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBF6A20).withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path1 = Path()
      ..moveTo(size.width * 0.1, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.6,
          size.width * 0.5, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.9,
          size.width * 0.9, size.height * 0.8);

    final path2 = Path()
      ..moveTo(size.width * 0.15, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.4,
          size.width * 0.6, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.6,
          size.width * 0.95, size.height * 0.55);

    final path3 = Path()
      ..moveTo(size.width * 0.05, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.2,
          size.width * 0.45, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.4,
          size.width * 0.9, size.height * 0.35);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
