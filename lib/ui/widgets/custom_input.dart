import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomInput extends StatelessWidget {
  final String hint;
  final bool isPassword;
  final bool showSuffix;

  const CustomInput({
    super.key, 
    required this.hint, 
    this.isPassword = false, 
    this.showSuffix = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.textDark, width: 2),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          suffixIcon: showSuffix ? const Icon(Icons.visibility_off_outlined, color: AppColors.textDark) : null,
        ),
      ),
    );
  }
}