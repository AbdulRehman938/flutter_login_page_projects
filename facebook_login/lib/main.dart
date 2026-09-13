import 'package:flutter/material.dart';
import 'facebook_login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color(0xFF005FD5)),
      ),
      home: const FacebookLoginScreen(),
    );
  }
}
