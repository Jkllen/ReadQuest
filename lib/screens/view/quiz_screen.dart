import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_quest/screens/view/boss_fight_screen.dart';
import 'package:read_quest/screens/viewmodel/quiz_view_model.dart';
import 'package:read_quest/styles/app_colors.dart';

class QuizScreen extends StatelessWidget {
  final String title;
  final String readingId;
  final String difficulty;

  const QuizScreen({
    super.key,
    required this.title,
    required this.readingId,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizViewModel()
        ..loadQuestions(
          readingId: readingId,
          difficulty: difficulty,
        ),
      child: QuizScreenBody(
        title: title,
        readingId: readingId,
        difficulty: difficulty,
      ),
    );
  }
}

class QuizScreenBody extends StatelessWidget {
  final String title;
  final String readingId;
  final String difficulty;

  const QuizScreenBody({
    super.key,
    required this.title,
    required this.readingId,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QuizViewModel>();

    if (viewModel.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7FBFF),
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (viewModel.questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7FBFF),
        body: SafeArea(
          child: Center(
            child: Text(
              'No quiz questions found for $difficulty.',
              style: const TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    final correctAnswer = viewModel.correctAnswer;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 89,
              padding: const EdgeInsets.symmetric(horizontal: 18),
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
                    child: Container(
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(21),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: viewModel.progressFactor,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    viewModel.progressText,
                    style: const TextStyle(
                      color: Color(0xFFA9A9A9),
                      fontSize: 15,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(33, 32, 33, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        viewModel.questionText,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 42),

                    // Choices
                    ...viewModel.options.map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 27),
                        child: QuizOption(
                          text: option,
                          isAnswered: viewModel.answered,
                          isSelected: viewModel.selectedAnswer == option,
                          isCorrect: option == correctAnswer,
                          onTap: () async{
                            viewModel.selectAnswer(option);
                          },
                        ),
                      ),
                    ),

                    // Feedback Container
                    if (viewModel.answered)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: (viewModel.selectedAnswer == correctAnswer
                              ? AppColors.quiz.correct
                              : AppColors.quiz.incorrect).withAlpha(24),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            width: 1.48,
                            color: (viewModel.selectedAnswer == correctAnswer
                                ? AppColors.quiz.correct
                                : AppColors.quiz.incorrect).withAlpha(48),
                          ),
                        ),
                        child: Text(
                          viewModel.explanation,
                          style: TextStyle(
                            color: viewModel.selectedAnswer == correctAnswer
                                ? AppColors.quiz.correct
                                : AppColors.quiz.incorrect,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1.43,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: viewModel.answered
                            ? () async {
                                final goToBoss = await viewModel.goNext(
                                  readingId: readingId,
                                  difficulty: difficulty,
                                );

                                if (!context.mounted) return;

                                if (goToBoss) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const BossFightScreen(),
                                    ),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF155DFC),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: const Color(0xFFDBEAFE),
                          disabledBackgroundColor: const Color(0xFF9DBDFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          viewModel.isLastQuestion
                              ? 'Face the Boss!'
                              : 'Next Question',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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

class QuizOption extends StatelessWidget {
  final String text;
  final bool isAnswered;
  final bool isSelected;
  final bool isCorrect;
  final Future<void> Function() onTap;

  const QuizOption({
    super.key,
    required this.text,
    required this.isAnswered,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent;
    Color textColor = const Color(0xFF6F6F6F);

    if (isAnswered) {
      if (isCorrect) {
        borderColor = AppColors.quiz.correct;
        textColor = AppColors.quiz.correct;
      } else if (isSelected) {
        borderColor = AppColors.quiz.incorrect;
        textColor = AppColors.quiz.incorrect;
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isAnswered ? null : () async {await onTap();},
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: double.infinity,
          height: 78,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: borderColor,
              width: borderColor == Colors.transparent ? 0 : 3,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
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