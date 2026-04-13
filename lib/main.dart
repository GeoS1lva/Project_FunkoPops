import 'package:flutter/material.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/update_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/add_funko_screen.dart';
import 'ui/screens/funko_listing_screen.dart';
import 'ui/screens/add_category_screen.dart';

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
      // home: const LoginScreen(),
      // home: const HomeScreen(),
      // home: const AddFunkoScreen(),
      // home: const AddCategoryScreen(),
      home: const FunkoListingScreen(),
      // home: const UpdateScreen(),
      // home: const FunkoListingScreen(),
      // home: const UpdateScreen(),
    );
  }
}
