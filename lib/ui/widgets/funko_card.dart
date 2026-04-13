import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../../models/funko_model.dart';

class FunkoCard extends StatelessWidget {
  final FunkoModel funko;
  final Color borderColor;
  final String badgeText;
  final Color badgeColor;

  const FunkoCard({
    Key? key,
    required this.funko,
    required this.borderColor,
    required this.badgeText,
    required this.badgeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: borderColor, width: 2.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    funko.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, e, s) => const Icon(Icons.toys),
                  ),
                ),
              ),
              Text(
                funko.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '#${funko.number}',
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
        Positioned(
          bottom: -12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.background, width: 2),
            ),
            child: Text(
              badgeText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
