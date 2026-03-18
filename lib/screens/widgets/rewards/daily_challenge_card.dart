import 'package:flutter/material.dart';
import 'package:read_quest/styles/card_styles.dart';

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({
    super.key,
    required this.title,
    required this.reward,
    required this.progress,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String reward;
  final String progress;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: CardStyles.whiteCard,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1), 
              shape: BoxShape.circle
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(reward, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          Text(
            progress,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}