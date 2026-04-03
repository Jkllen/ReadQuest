import 'package:flutter/material.dart';
import 'package:read_quest/styles/app_colors.dart';

class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({
    super.key, 
    required this.streak
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 39,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.home.streakCard.withValues(alpha: 0.2),
        border: Border.all(color: AppColors.home.streakCard, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$streak',
            style: TextStyle(
              color: AppColors.home.streakCard,
              fontSize: 16,
              fontFamily: 'Mojangles',
              fontWeight: FontWeight.w400,
              height: 1
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Streak',
            style: TextStyle(
              color: AppColors.home.streakCard,
              fontSize: 16,
              fontFamily: 'Mojangles',
              fontWeight: FontWeight.w400,
              height: 1
            ),
          ),
        ],
      ),
    );
  }
}
