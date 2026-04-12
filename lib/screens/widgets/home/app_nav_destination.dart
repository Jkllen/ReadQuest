import 'package:flutter/material.dart';
import 'package:read_quest/styles/app_colors.dart';

class AppNavDestination extends StatelessWidget {
  const AppNavDestination({
    super.key,
    required this.icon,
    required this.label,
    this.unselectedColor = AppPalette.white,
    this.selectedColor = AppPalette.aqua,
  });

  final IconData icon;
  final String label;
  final Color unselectedColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: Icon(icon, color: unselectedColor),
      selectedIcon: Icon(icon, color: selectedColor),
      label: label,
    );
  }
}
