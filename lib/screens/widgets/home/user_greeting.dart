import 'package:flutter/material.dart';

class UserGreeting extends StatelessWidget {
  final String username;
  final int level;

  const UserGreeting({
    super.key, 
    required this.username, 
    required this.level
    });

  String getLevelTitle(int level) {
    if (level == 0) return "Newbie";
    if (level < 5) return "Reader";
    if (level < 10) return "Scholar";
    return "Master";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, $username!',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Maname',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Level $level ${getLevelTitle(level)}',
          style: const TextStyle(
            color: Color(0xFF00ACF6),
            fontSize: 14,
            fontFamily: 'Maname',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

