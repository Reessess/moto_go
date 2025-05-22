import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moto_go/providers/user_provider.dart';
import 'Screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
