import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomBottomNav extends StatefulWidget {
  final Function(int) onTabSelected;

  const CustomBottomNav({super.key, required this.onTabSelected});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTabSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: const Border(top: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_filled, 0),
          _buildNavItem(Icons.grid_view_rounded, 1),
          _buildNavItem(Icons.notifications_rounded, 2),
          _buildNavItem(Icons.settings_rounded, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 32,
            color: isSelected
                ? AppColors.navIconSelected
                : AppColors.navIconUnselected,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 4,
              width: 20,
              decoration: BoxDecoration(
                color: AppColors.navIconSelected,
                borderRadius: BorderRadius.circular(2),
              ),
            )
          else
            const SizedBox(height: 8),
        ],
      ),
    );
  }
}
