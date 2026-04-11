import 'package:flutter/material.dart';
import 'ui/screens/login_screen.dart'; // Importando a sua tela de login

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pop!Collector',
      debugShowCheckedModeBanner: false, // Tira a faixa de debug do emulador
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5F7A)), // Usando o seu azul primário como base
        useMaterial3: true,
      ),
      // Aqui é onde a mágica acontece: o app agora abre direto na sua tela!
      home: const LoginScreen(), 
    );
  }
}