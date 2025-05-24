import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moto_go/providers/user_provider.dart'; // <-- Import PaymentProvider
import 'Screens/login_screen.dart';
import 'package:moto_go/providers/bike_provider.dart';
import 'package:moto_go/providers/booking_provider.dart';
import 'package:moto_go/Screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BikeProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App',
      home: const LoginScreen(),
    );
  }
}
