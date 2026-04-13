import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../app_colors.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../widgets/app_logo.dart';
import '../widgets/custom_label.dart';

import '../../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha os dois campos!'),
          backgroundColor: AppColors.accentRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final user = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao entrar.'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildEpicAnimatedBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    'Pop!Collector',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 25),

                  const AppLogo(),

                  const SizedBox(height: 20),
                  const Text(
                    'Bem-vindo',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 40),

                  const CustomLabel(text: "Colecionador", isRequired: true),
                  CustomInput(hint: "E-mail/CPF", controller: _emailController),

                  const SizedBox(height: 20),
                  const CustomLabel(text: "Senha"),
                  CustomInput(
                    hint: "Senha",
                    controller: _passwordController,
                    isPassword: true,
                    showSuffix: true,
                  ),

                  const SizedBox(height: 35),

                  _isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.primaryBlue,
                        )
                      : CustomButton(
                          text: 'Entrar',
                          color: AppColors.primaryBlue,
                          textColor: Colors.white,
                          onPressed: _handleLogin,
                        ),

                  const SizedBox(height: 15),

                  if (!_isLoading)
                    CustomButton(
                      text: 'Novo Usuário',
                      color: AppColors.accentYellow,
                      textColor: Colors.black,
                      onPressed: () {},
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpicAnimatedBackground() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double t = _controller.value * 2 * math.pi;

        final double lev1 = math.sin(t);
        final double lev2 = math.cos(t);
        final double lev3 = math.sin(t + math.pi / 4);
        final double lev4 = math.cos(t + math.pi / 2);
        final double scalePulse = 1.0 + (0.1 * math.sin(t * 2));

        return Stack(
          children: [
            Container(color: const Color(0xFFF6F1E3)),

            Positioned(
              top: -100 + (30 * lev1),
              left: -100 + (20 * lev2),
              child: Transform.scale(
                scale: scalePulse,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5DADE2).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 150 + (40 * lev3),
              left: -30,
              child: Transform.rotate(
                angle: t / 2,
                child: Container(
                  width: 120,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFD62828).withOpacity(0.2),
                      width: 6,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -150 + (30 * lev4),
              right: -80 + (20 * lev1),
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  color: const Color(0xFFD62828).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              bottom: 250 + (25 * lev2),
              right: -40,
              child: Transform.rotate(
                angle: -t,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF39C12).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 50 + (15 * lev2),
              right: 20 + (10 * lev3),
              child: Transform.rotate(
                angle: t / 4,
                child: Column(
                  children: List.generate(
                    4,
                    (i) => Row(
                      children: List.generate(
                        4,
                        (j) => Container(
                          margin: const EdgeInsets.all(4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D7B93).withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 100 + (20 * lev4),
              right: 60,
              child: Transform.rotate(
                angle: t * 2,
                child: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFF39C12),
                  size: 50,
                ),
              ),
            ),

            Positioned(
              top: 220 + (15 * lev1),
              left: 40,
              child: Transform.rotate(
                angle: -t,
                child: const Icon(
                  Icons.star_border_rounded,
                  color: Color(0xFFD62828),
                  size: 40,
                ),
              ),
            ),

            Positioned(
              bottom: 180 + (25 * lev3),
              left: 70,
              child: Transform.rotate(
                angle: t * 1.5,
                child: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFF0D7B93),
                  size: 25,
                ),
              ),
            ),

            Positioned(
              bottom: 80 + (10 * lev2),
              right: 80,
              child: Transform.rotate(
                angle: -t / 1.5,
                child: Icon(
                  Icons.star_rounded,
                  color: const Color(0xFFF39C12).withOpacity(0.6),
                  size: 30,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
