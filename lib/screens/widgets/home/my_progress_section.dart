import 'package:flutter/material.dart';

class MyProgressSection extends StatelessWidget {
  final int currentLevel;
  final int streakDays;
  final int wordsLearned;

  const MyProgressSection({
    super.key,
    required this.currentLevel,
    required this.streakDays,
    required this.wordsLearned,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Progress',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        ProgressListItem(
          title: 'Current Level',
          valueText: '$currentLevel',
          pillBg: const Color(0xFFDBEAFE),
          valueColor: const Color(0xFF432DD7),
          valueFontSize: 18,
        ),
        const SizedBox(height: 14),
        ProgressListItem(
          title: 'Reading Streak',
          valueText: '$streakDays days',
          pillBg: const Color(0xFFFFEDD4),
          valueColor: const Color(0xFFCD681F),
          valueFontSize: 14,
        ),
        const SizedBox(height: 14),
        ProgressListItem(
          title: 'Words Learned',
          valueText: '$wordsLearned',
          pillBg: const Color(0xFFDBEAFE),
          valueColor: const Color(0xFF432DD7),
          valueFontSize: 18,
        ),
      ],
    );
  }
}

class ProgressListItem extends StatelessWidget {
  final String title;
  final String valueText;

  final Color pillBg;
  final Color valueColor;
  final double valueFontSize;

  const ProgressListItem({
    super.key,
    required this.title,
    required this.valueText,
    required this.pillBg,
    required this.valueColor,
    required this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 71,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFE2E2E2), width: 2),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4F4F4F),
              fontSize: 18,
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(10.5),
            ),
            child: Text(
              valueText,
              style: TextStyle(
                color: valueColor,
                fontSize: valueFontSize,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
