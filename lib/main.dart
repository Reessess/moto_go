import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moto_go/providers/user_provider.dart';
import 'package:moto_go/providers/bike_provider.dart';
import 'package:moto_go/providers/booking_provider.dart';
import 'package:moto_go/providers/payment_provider.dart'; // <-- ✅ Import PaymentProvider
import 'Screens/login_screen.dart';
import 'package:moto_go/Screens/home_screen.dart';
import 'package:moto_go/Model/booking.dart';
import 'package:moto_go/Payments/payment_screen.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BikeProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()), // <-- ✅ Add PaymentProvider
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
      title: 'motoGO',
      home: const LoginScreen(),

      // Replace your routes with this onGenerateRoute:
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (_) => const Homescreen());

          case '/payment':
            final booking = settings.arguments;
            if (booking == null || booking is! Booking) {
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(child: Text('Booking data is missing or invalid')),
                ),
              );
            }
            return MaterialPageRoute(
              builder: (_) => PaymentScreen(booking: booking as Booking),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Route not found')),
              ),
            );
        }
      },
    );
  }
}


