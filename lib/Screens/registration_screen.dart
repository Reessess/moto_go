import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_screen.dart';  // Import your login screen here

class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({super.key});

  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

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

    final url = Uri.parse('http://192.168.5.129:3000/api/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "first_name": firstNameController.text.trim(),
        "middle_name": middleNameController.text.trim().isEmpty ? null : middleNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "username": usernameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -100,
            child: Transform.rotate(
              angle: -50.9999 * (3.14 / 180),
              child: Container(
                width: 600,
                height: 500,
                decoration: BoxDecoration(
                  color: const Color(0xFF96D13A),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Positioned(
            top: -450,
            right: -100,
            child: Transform.rotate(
              angle: -50.9999 * (3.14 / 180),
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: const Color(0xFF1D2C69),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 48,
                      color: Color(0xFFBF6A20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildTextField('First Name *', firstNameController),
                  buildTextField('Middle Name', middleNameController),
                  buildTextField('Last Name *', lastNameController),
                  buildTextField('Username *', usernameController),
                  buildTextField('Email *', emailController),
                  buildTextField('Phone Number', phoneController),
                  buildDateOfBirthField(),
                  const SizedBox(height: 20),
                  buildTextField('Password *', passwordController, isPassword: true),
                  buildTextField('Confirm Password *', repeatPasswordController, isPassword: true),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(191, 106, 32, 1),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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

  Widget buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color.fromRGBO(191, 106, 32, 1),
            fontFamily: 'Inter',
            fontSize: 16,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(191, 106, 32, 1), width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget buildDateOfBirthField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: dobController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          labelStyle: const TextStyle(
            color: Color.fromRGBO(191, 106, 32, 1),
            fontFamily: 'Inter',
            fontSize: 16,
          ),
          suffixIcon: const Icon(Icons.calendar_today, color: Color.fromRGBO(191, 106, 32, 1)),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(191, 106, 32, 1), width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                    primary: Color.fromRGBO(191, 106, 32, 1),
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Color.fromRGBO(191, 106, 32, 1),
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
    );
  }
}
