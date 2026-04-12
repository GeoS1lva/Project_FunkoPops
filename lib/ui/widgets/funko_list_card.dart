import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../../models/funko_model.dart';

class FunkoListCard extends StatelessWidget {
  final FunkoModel funko;
  final Color borderColor;
  final VoidCallback onEditTap;

  const FunkoListCard({
    Key? key,
    required this.funko,
    required this.borderColor,
    required this.onEditTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.black87,
              child: funko.image.isNotEmpty
                  ? Image.network(
                      funko.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  : const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 30,
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  funko.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  funko.categoryName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderNeutral, width: 2),
                color: Colors.transparent,
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: AppColors.textDark,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
