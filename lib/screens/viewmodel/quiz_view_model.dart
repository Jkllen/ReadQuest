import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_quest/services/quiz_service.dart';
import 'package:read_quest/services/user_services.dart';


class QuizViewModel extends ChangeNotifier {
  final QuizService quizService;
  final UserService userService;

  QuizViewModel({QuizService? quizService, UserService? userService})
      : quizService = quizService ?? QuizService(),
        userService = userService ?? UserService();

  bool isLoading = true;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> questions = [];

  int currentIndex = 0;
  String? selectedAnswer;
  bool answered = false;
  int score = 0;

  String subDifficulty = 'mid';

  Future<void> loadQuestions({
    required String readingId,
    required String difficulty,
  }) async {
    isLoading = true;

    // Added a reset state before loading a new quiz
    questions = [];
    currentIndex = 0;
    selectedAnswer = null;
    answered = false;
    score = 0;
    subDifficulty = 'mid';

    notifyListeners();

    try {
      subDifficulty = await quizService.determineSubDifficulty(
        readingId: readingId,
        difficulty: difficulty,
      );

      final result = await quizService.getQuestions(
        readingId: readingId,
        difficulty: difficulty,
        subDifficulty: subDifficulty,
      );

      questions = result;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Map<String, dynamic> get currentQuestionData {
    if (questions.isEmpty || currentIndex >= questions.length) return {};
    return questions[currentIndex].data();
  }

  String get questionText =>
      (currentQuestionData['question'] ?? '').toString();

  List<String> get options =>
      List<String>.from(currentQuestionData['options'] ?? []);

  String get correctAnswer =>
      (currentQuestionData['correctAnswer'] ?? '').toString();

  String get explanation =>
      (currentQuestionData['explanation'] ?? '').toString();

  String get skill =>
      (currentQuestionData['skill'] ?? '').toString();

  String get progressText =>
      questions.isEmpty ? '0/0' : '${currentIndex + 1}/${questions.length}';

  double get progressFactor =>
      questions.isEmpty ? 0.0 : (currentIndex + 1) / questions.length;

  bool get isLastQuestion =>
      questions.isNotEmpty && currentIndex == questions.length - 1;

  Future<void> selectAnswer(String option) async{
    if (answered || questions.isEmpty) return;

    selectedAnswer = option;
    answered = true;

    if (option == correctAnswer) {
      score++;
      await userService.incrementSkillStat(skill: skill);
    }

    notifyListeners();
  }

  Future<bool> goNext({
    required String readingId,
    required String difficulty,
  }) async {
    if (!answered || questions.isEmpty) return false;

    if (isLastQuestion) {
      await quizService.saveQuizResult(
        readingId: readingId,
        difficulty: difficulty,
        subDifficulty: subDifficulty,
        score: score,
        totalQuestions: questions.length,
      );

      await userService.updateWeeklyProgress(
        score: score, 
        totalQuestions: questions.length
      );

      await userService.updateWeeklyGrowth();

      return true;
    }

    currentIndex++;
    selectedAnswer = null;
    answered = false;
    notifyListeners();
    return false;
  }
}