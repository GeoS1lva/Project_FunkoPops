import 'package:flutter/material.dart';
import 'ui/screens/login_screen.dart';
import 'ui/widgets/custom_menubar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pop!Collector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5F7A)),
      ),
      home: const LoginScreen(), 
    );
  }
}