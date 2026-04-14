import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  QuizService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  Future<String> determineSubDifficulty({
    required String readingId,
    required String difficulty,
  }) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return 'mid';

    final resultDoc = await firestore
        .collection('users')
        .doc(uid)
        .collection('quiz_results')
        .doc('${readingId}_$difficulty')
        .get();

    if (!resultDoc.exists) {
      return 'mid';
    }

    final data = resultDoc.data() ?? {};
    final score = (data['score'] as num?)?.toDouble() ?? 0.0;
    final totalQuestions = (data['totalQuestions'] as num?)?.toDouble() ?? 0.0;

    if (totalQuestions <= 0) return 'mid';

    final accuracy = score / totalQuestions;

    if (accuracy < 0.40) return 'low';
    if (accuracy < 0.80) return 'mid';
    return 'high';
  }

  int getQuestionLimit({
    required String difficulty,
    required String subDifficulty,
  }) {
    switch (difficulty) {
      case 'easy':
        switch (subDifficulty) {
          case 'low':
            return 3;
          case 'mid':
            return 4;
          case 'high':
            return 5;
          default:
            return 4;
        }

      case 'normal':
        switch (subDifficulty) {
          case 'low':
            return 4;
          case 'mid':
            return 5;
          case 'high':
            return 6;
          default:
            return 5;
        }

      case 'hard':
        switch (subDifficulty) {
          case 'low':
            return 5;
          case 'mid':
            return 6;
          case 'high':
            return 7;
          default:
            return 6;
        }

      default:
        return 4;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getQuestions({
    required String readingId,
    required String difficulty,
    required String subDifficulty,
  }) async {
    final questionLimit = getQuestionLimit(
      difficulty: difficulty,
      subDifficulty: subDifficulty,
    );

    final snapshot = await firestore
        .collection('readings')
        .doc(readingId)
        .collection('quizzes')
        .doc(difficulty)
        .collection('questions')
        .where('subDifficulty', isEqualTo: subDifficulty)
        .orderBy('order')
        .limit(questionLimit)
        .get();

    return snapshot.docs;
  }

  // --- NEW: Dedicated Boss Fight Fetcher ---
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getBossQuestions({
    required String readingId,
    required String difficulty,
  }) async {
    final snapshot = await firestore
        .collection('readings')
        .doc(readingId)
        .collection('quizzes')
        .doc(difficulty)
        .collection('questions')
        .where('subDifficulty', isEqualTo: 'boss') // Filters only for boss questions
        .orderBy('order')
        .get();

    return snapshot.docs;
  }

  Future<void> saveQuizResult({
    required String readingId,
    required String difficulty,
    required String subDifficulty,
    required int score,
    required int totalQuestions,
  }) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    final accuracy = totalQuestions == 0 ? 0.0 : score / totalQuestions;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('quiz_results')
        .doc('${readingId}_$difficulty')
        .set({
      'readingId': readingId,
      'difficulty': difficulty,
      'subDifficulty': subDifficulty,
      'score': score,
      'totalQuestions': totalQuestions,
      'accuracy': accuracy,
      'completedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}