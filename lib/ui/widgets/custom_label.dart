import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const CustomLabel({super.key, required this.text, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6, left: 4),
        child: Text.rich(
          TextSpan(
            text: text,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Colors.black87,
            ),
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
      ),
    );
  }
}
