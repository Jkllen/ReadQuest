import 'package:flutter/material.dart';
import 'package:read_quest/screens/view/quiz_screen.dart';
import 'package:read_quest/styles/app_colors.dart';

class DifficultySelectionScreen extends StatelessWidget {
  final String title;
  final String readingId;

  const DifficultySelectionScreen({
    super.key,
    required this.title,
    required this.readingId,
  });

  void openQuiz(BuildContext context, String difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          title: title,
          readingId: readingId,
          difficulty: difficulty,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 89,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF747474),
                            fontSize: 15,
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'QUIZ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
                    const Text(
                      'READ QUEST',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 36,
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Choose a difficulty:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 31,
                        vertical: 24,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 10.9,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          DifficultyButton(
                            label: 'EASY',
                            color: AppColors.difficulty.easy,
                            onTap: () => openQuiz(context, 'easy'),
                          ),
                          const SizedBox(height: 28),
                          DifficultyButton(
                            label: 'NORMAL',
                            color: AppColors.difficulty.medium,
                            onTap: () => openQuiz(context, 'normal'),
                          ),
                          const SizedBox(height: 28),
                          DifficultyButton(
                            label: 'HARD',
                            color: AppColors.difficulty.hard,
                            onTap: () => openQuiz(context, 'hard'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DifficultyButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const DifficultyButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 291,
      height: 71,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(42),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(42),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}