import 'dart:async'; // --- NEW: Required for Timer ---
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_quest/services/quiz_service.dart';
import 'package:read_quest/services/user_services.dart';

class BossFightViewModel extends ChangeNotifier {
  final QuizService quizService;
  final UserService userService;

  BossFightViewModel({QuizService? quizService, UserService? userService})
      : quizService = quizService ?? QuizService(),
        userService = userService ?? UserService();

  // --- FUTURE-PROOFING: Remember the current story and difficulty ---
  String currentReadingId = "";
  String currentDifficulty = "";

  bool isLoading = true;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> questions = [];

  // Standard Quiz States
  int currentIndex = 0;
  String? selectedAnswer;
  bool answered = false;
  int score = 0;
  String subDifficulty = 'boss'; // Default to boss

  // --- Boss Fight Mechanics ---
  String playerName = 'HERO'; // Default fallback name
  
  int maxPlayerHealth = 3; // Player dies after 3 wrong answers
  int playerHealth = 3;
  
  int maxBossHealth = 2; // Hardcoded to 2 for the victory condition
  int bossHealth = 2;

  bool isGameOver = false;
  bool isVictory = false;

  // --- Timer Mechanics ---
  Timer? _timer;
  int remainingTime = 15; // Set the question time limit here
  bool isTimeUp = false;

  @override
  void dispose() {
    _timer?.cancel(); // Prevent memory leaks when the screen closes
    super.dispose();
  }

  Future<void> loadBossFight({
    required String readingId,
    required String difficulty,
  }) async {
    // --- SAVE THE CURRENT BATTLE INFO ---
    currentReadingId = readingId;
    currentDifficulty = difficulty;

    isLoading = true;
    _timer?.cancel(); // Reset timer if reloading

    // --- FETCH DYNAMIC PLAYER NAME ---
    try {
      // NOTE: Adjust 'getCurrentUserName' to match the exact method in your UserService!
      final userName = await userService.getUsername(); 
      if (userName != null && userName.isNotEmpty) {
        playerName = userName;
      }
    } catch (e) {
      print("Could not fetch user name: $e");
    }

    // Reset all states for a fresh fight
    questions = [];
    currentIndex = 0;
    selectedAnswer = null;
    answered = false;
    score = 0;
    subDifficulty = 'boss'; // Force the state to 'boss'
    
    playerHealth = maxPlayerHealth;
    isGameOver = false;
    isVictory = false;
    isTimeUp = false;

    notifyListeners();

    try {
      // Fetch ONLY the boss questions using our dedicated method
      final result = await quizService.getBossQuestions(
        readingId: readingId,
        difficulty: difficulty,
      );

      questions = result;
      
      // Set the boss health specifically to 2
      maxBossHealth = 2;
      bossHealth = maxBossHealth;

      isLoading = false;
      notifyListeners();

      // Start the timer once questions are loaded
      if (questions.isNotEmpty) {
        startTimer();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // --- Timer Methods ---
  void startTimer() {
    _timer?.cancel();
    remainingTime = 15; // Reset to max time
    isTimeUp = false;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        notifyListeners();
      } else {
        timer.cancel();
        isTimeUp = true;
        answered = true; // Lock the choices so the user can't tap them
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void retryQuestion() {
    isTimeUp = false;
    answered = false;
    selectedAnswer = null;
    startTimer(); // Restart the clock for the same question
  }

  // Question Data Getters
  Map<String, dynamic> get currentQuestionData {
    if (questions.isEmpty || currentIndex >= questions.length) return {};
    return questions[currentIndex].data();
  }

  String get questionText => (currentQuestionData['question'] ?? '').toString();
  List<String> get options => List<String>.from(currentQuestionData['options'] ?? []);
  String get correctAnswer => (currentQuestionData['correctAnswer'] ?? '').toString();
  String get explanation => (currentQuestionData['explanation'] ?? '').toString();
  String get skill => (currentQuestionData['skill'] ?? '').toString();

  // Health Bar Helpers
  double get playerHealthFactor => (playerHealth / maxPlayerHealth).clamp(0.0, 1.0);
  double get bossHealthFactor => maxBossHealth == 0 ? 0.0 : (bossHealth / maxBossHealth).clamp(0.0, 1.0);

  bool get isLastQuestion => questions.isNotEmpty && currentIndex == questions.length - 1;

  Future<void> selectAnswer(String option) async {
    // Prevent selection if time is up
    if (answered || questions.isEmpty || isGameOver || isVictory || isTimeUp) return;

    stopTimer(); // Stop the clock when an answer is chosen
    
    selectedAnswer = option;
    answered = true;

    if (option == correctAnswer) {
      // Correct Answer: Boss takes damage
      score++;
      bossHealth--;
      await userService.incrementSkillStat(skill: skill);
      
      // If boss hits 0, they win immediately!
      if (bossHealth <= 0) {
        isVictory = true;
      }
    } else {
      // Incorrect Answer: Player takes damage
      playerHealth--;
      
      // If player hits 0, game over immediately!
      if (playerHealth <= 0) {
        isGameOver = true;
      }
    }

    notifyListeners();
  }

  Future<bool> goNext({
    required String readingId,
    required String difficulty,
  }) async {
    if (!answered || questions.isEmpty) return false;

    // Check if the fight is over (Win, Loss, or out of questions)
    if (isGameOver || isVictory || isLastQuestion) {
      
      // Only award full completion stats and XP if it's a Victory
      if (isVictory) {
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

        // Bonus multiplier for beating a boss
        await userService.addQuizRewards(
          xpAmount: (score * 5) + 50, // Added a 50 XP flat boss bonus
          wordsLearnedAmount: 1,
        );
      }

      return true; // Returns true to tell the UI the session is completely done
    }

    // Move to the next question
    currentIndex++;
    selectedAnswer = null;
    answered = false;
    
    startTimer(); // Start the clock for the next question
    
    notifyListeners();
    return false;
  }
}