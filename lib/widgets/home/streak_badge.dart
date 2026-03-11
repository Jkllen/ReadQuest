import 'package:flutter/material.dart';

class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 39,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        border: Border.all(color: const Color(0xFFDC7C52), width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$streak',
            style: const TextStyle(
              color: Color(0xFFFF6900),
              fontSize: 16,
              fontFamily: 'Mojangles',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Streak',
            style: TextStyle(
              color: Color(0xFFFF6900),
              fontSize: 16,
              fontFamily: 'Mojangles',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
