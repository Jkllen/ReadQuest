import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getUsername() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    return doc.data()?['username'] as String?;
  }

  // RealTime Stream of A User
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }

  // User Created Doc On Register
  Future<void> createUserDoc({
    required String uid,
    required String username,
  }) async {
    await _db.collection('users').doc(uid).set({
      "username": username,
      "level": 0,
      "streak": 0,
      "currentXp": 0,
      "targetXp": 2000,
      "totalXpEarned": 0,
      "badgesWon": 0,
      "streakDays": 0,
      "wordsLearned": 0,
      "currentStageTitle": "Stage title",

      // Stats screen fields
      "comprehension": 0,
      "vocabulary": 0,
      "readingSpeed": 0,
      "weeklyGrowth": 0,
      "weeklyProgress": [0, 0, 0, 0, 0, 0],

      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(
      {
        ...data,
        "updatedAt": FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> incrementSkillStat({
    required String skill,
    int amount = 1,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    if (skill != 'comprehension' && skill != 'vocabulary') return;

    await _db.collection('users').doc(uid).set({
      skill: FieldValue.increment(amount),
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateReadingSpeed({
    required int readingSpeed,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).set({
      "readingSpeed": readingSpeed,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateWeeklyProgress({
    required int score,
    required int totalQuestions,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userRef = _db.collection('users').doc(uid);
    final snapshot = await userRef.get();
    final data = snapshot.data() ?? {};

    final List<dynamic> oldProgress =
        (data['weeklyProgress'] as List<dynamic>?) ?? [0, 0, 0, 0, 0, 0];

    final double percent =
        totalQuestions == 0 ? 0 : (score / totalQuestions) * 100;

    final List<dynamic> updatedProgress = List<dynamic>.from(oldProgress);

    if (updatedProgress.length < 6) {
      while (updatedProgress.length < 6) {
        updatedProgress.add(0);
      }
    }

    updatedProgress.removeAt(0);
    updatedProgress.add(percent.round());

    await userRef.set({
      "weeklyProgress": updatedProgress,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateWeeklyGrowth() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userRef = _db.collection('users').doc(uid);
    final snapshot = await userRef.get();
    final data = snapshot.data() ?? {};

    final List<dynamic> weeklyProgress =
        (data['weeklyProgress'] as List<dynamic>?) ?? [0, 0, 0, 0, 0, 0];

    if (weeklyProgress.length < 2) {
      await userRef.set({
        "weeklyGrowth": 0,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }

    final num previous = weeklyProgress[weeklyProgress.length - 2] ?? 0;
    final num latest = weeklyProgress[weeklyProgress.length - 1] ?? 0;

    final int growth = (latest - previous).round();

    await userRef.set({
      "weeklyGrowth": growth,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> addQuizRewards({
    int xpAmount = 10,
    int wordsLearnedAmount = 1,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).set({
      "currentXp": FieldValue.increment(xpAmount),
      "totalXpEarned": FieldValue.increment(xpAmount),
      "wordsLearned": FieldValue.increment(wordsLearnedAmount),
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}