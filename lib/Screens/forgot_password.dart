import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moto_go/providers/user_provider.dart';

// Custom Clipper for Abstract Background
class AbstractMapClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.35);
    path.quadraticBezierTo(
      size.width * 0.3, size.height * 0.45,
      size.width * 0.5, size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.05,
      size.width, size.height * 0.2,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (title == "Success") {
                Navigator.of(context).pop();
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final userProv = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await userProv.resetPassword(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      if (result['success']) {
        _showDialog('Success', result['message']);
      } else {
        _showDialog('Failed', result['message']);
      }
    } catch (e) {
      _showDialog('Error', 'An error occurred. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validateUsername(String? value) =>
      value == null || value.trim().isEmpty ? 'Enter your username.' : null;

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your email.';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return !emailRegex.hasMatch(value.trim()) ? 'Enter a valid email.' : null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your phone number.';
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    return !phoneRegex.hasMatch(value.trim()) ? 'Enter a valid phone number.' : null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter a new password.';
    return value.trim().length < 6 ? 'Password must be at least 6 characters.' : null;
  }

  String? _validateRepeatPassword(String? value) =>
      value != newPasswordController.text.trim() ? 'Passwords do not match.' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: AbstractMapClipper(),
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF6E9D6), Color(0xFFF9D3B4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Image.asset('assets/Icon.PNG', height: 100),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9D3B4), // Updated card color
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Reset Your Password',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D2D69),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: usernameController,
                            label: 'Username',
                            icon: Icons.person,
                            validator: _validateUsername,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: emailController,
                            label: 'Email',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: phoneController,
                            label: 'Phone Number',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            validator: _validatePhone,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: newPasswordController,
                            label: 'New Password',
                            icon: Icons.lock,
                            obscureText: true,
                            validator: _validateNewPassword,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: repeatPasswordController,
                            label: 'Repeat New Password',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: _validateRepeatPassword,
                          ),
                          const SizedBox(height: 30),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1D2D69),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _submitForgotPassword,
                              child: const Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF1D2D69)),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1D2D69), width: 2),
        ),
      ),
    );
  }
}
