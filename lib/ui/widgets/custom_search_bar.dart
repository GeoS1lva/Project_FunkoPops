import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.navIconUnselected, width: 2),
            gradient: const LinearGradient(
              stops: [0.0, 0.25, 0.25, 0.50, 0.50, 0.75, 0.75, 1.0],
              colors: [
                AppColors.searchPurple,
                AppColors.searchPurple,
                AppColors.searchRed,
                AppColors.searchRed,
                AppColors.searchYellow,
                AppColors.searchYellow,
                AppColors.searchTeal,
                AppColors.searchTeal,
              ],
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(Icons.search, color: AppColors.navIconUnselected),
                SizedBox(width: 8),
                Text(
                  'Busca',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.navIconUnselected,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
