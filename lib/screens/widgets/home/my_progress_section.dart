import 'package:flutter/material.dart';
import 'package:read_quest/screens/widgets/home/progress_list_item.dart';

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
