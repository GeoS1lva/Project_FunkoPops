import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../../models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final Color backgroundColor;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        height: 80,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.black12, width: 1),
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
            const SizedBox(width: 20),
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black87,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                category.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
