import 'package:flutter/material.dart';
import 'registration_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background shapes
          Positioned(
            top: -120,
            left: -100,
            child: Transform.rotate(
              angle: -50.9999 * (3.14 / 180),
              child: Container(
                width: 600,
                height: 500,
                decoration: BoxDecoration(
                  color: Color(0xFF691D1D),
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
                  color: Color(0xFF1D2C69),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/images/Image1.png'),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 48,
                      color: Color(0xFFBF6A20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFE1A46F),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Color(0xFFBF6A20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1D2D69),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          // Handle login logic
                          print("Username: ${usernameController.text}");
                          print("Password: ${passwordController.text}");
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1F3229),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          // Navigate to the Registration screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationWidget(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
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
