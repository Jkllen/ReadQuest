import 'package:flutter/material.dart';
import 'package:read_quest/styles/card_styles.dart';

class SkillCard extends StatelessWidget {
  final String title;
  final int percentage;
  final Color accentColor;
  final IconData iconData;

  const SkillCard({
    super.key,
    required this.title,
    required this.percentage,
    required this.accentColor,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final double safePercentage = (percentage.clamp(0, 100)) / 100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: CardStyles.borderCard(),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.075),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(iconData, color: accentColor, size: 26),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                    Text(
                      "$percentage%",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: safePercentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}