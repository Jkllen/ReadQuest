import 'package:flutter/material.dart';
import 'package:read_quest/screens/widgets/home/streak_badge.dart';
import 'package:read_quest/screens/widgets/menu_header.dart';
import 'package:read_quest/styles/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String username;
  final int level;
  final int streak;

  const HomeHeader({
    super.key,
    required this.username,
    required this.level,
    required this.streak,
  });

  String getLevelTitle(int level) {
    if (level == 0) return "Newbie";
    if (level < 5) return "Reader";
    if (level < 10) return "Scholar";
    return "Master";
  }

  @override
  Widget build(BuildContext context) {
    return MenuHeader(
      headerText: 'Welcome, $username!',
      subHeaderText: 'Level $level ${getLevelTitle(level)}',
      headerStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: 'Maname',
        fontWeight: FontWeight.w700,
      ),
      subHeaderStyle: const TextStyle(
        color: AppColors.accent,
        fontSize: 14,
        fontFamily: 'Maname',
        fontWeight: FontWeight.w700,
      ),
      trailingWidget: StreakBadge(streak: streak),
    );
  }
}
