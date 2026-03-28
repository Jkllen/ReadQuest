import 'package:flutter/material.dart';
import 'package:read_quest/screens/widgets/home/progress_list_item.dart';
import 'package:read_quest/styles/app_spacings.dart';

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
        SizedBox(height: AppSpacings.underTitle),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacings.betweenItems,
          children: [
            ProgressListItem(
              title: 'Current Level',
              valueText: '$currentLevel',
              valueColor: const Color(0xFF432DD7),
            ),
            ProgressListItem(
              title: 'Reading Streak',
              valueText: '$streakDays',
              valueColor: const Color(0xFFCD681F),
            ),
            ProgressListItem(
              title: 'Words Learned',
              valueText: '$wordsLearned',
              valueColor: const Color(0xFF432DD7),
            ),
          ],
        ),
      ],
    );
  }
}
