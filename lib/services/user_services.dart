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
      "weeklyProgress": [0, 0, 0, 0, 0, 0, 0],

      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set({
      ...data,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
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

  Future<void> updateReadingSpeed({required int readingSpeed}) async {
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

    final double percent = totalQuestions == 0
        ? 0
        : (score / totalQuestions) * 100;
    final int progressToAdd = percent.round();

    final docRef = _db.collection('users').doc(uid);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final data = snapshot.data()!;

      List<dynamic> rawProgress =
          data['weeklyProgress'] ?? [0, 0, 0, 0, 0, 0, 0];
      List<int> weeklyProgress = rawProgress
          .map((e) => (e as num).toInt())
          .toList();

      while (weeklyProgress.length < 7) {
        weeklyProgress.insert(0, 0);
      }
      if (weeklyProgress.length > 7) {
        weeklyProgress = weeklyProgress.sublist(weeklyProgress.length - 7);
      }

      int dailyCorrect = (data['dailyCorrect'] ?? 0).toInt();
      int dailyTotal = (data['dailyTotal'] ?? 0).toInt();

      Timestamp? lastUpdatedTs = data['updatedAt'] as Timestamp?;
      DateTime now = DateTime.now();
      DateTime todayMidnight = DateTime(now.year, now.month, now.day);

      int daysPassed = 0;
      if (lastUpdatedTs != null) {
        DateTime lastUpdate = lastUpdatedTs.toDate();
        DateTime lastUpdateMidnight = DateTime(
          lastUpdate.year,
          lastUpdate.month,
          lastUpdate.day,
        );
        daysPassed = todayMidnight.difference(lastUpdateMidnight).inDays;
      }

      if (daysPassed > 0) {
        dailyCorrect = 0;
        dailyTotal = 0;
        if (daysPassed >= 7) {
          weeklyProgress = [0, 0, 0, 0, 0, 0, 0];
        } else {
          weeklyProgress.removeRange(0, daysPassed);
          for (int i = 0; i < daysPassed; i++) {
            weeklyProgress.add(0);
          }
        }
      }

      dailyCorrect += score;
      dailyTotal += totalQuestions;
      double dailyPercent = dailyTotal == 0
          ? 0
          : (dailyCorrect / dailyTotal) * 100;
      weeklyProgress[6] = dailyPercent.round();

      int yesterdayScore = weeklyProgress[5];
      int todayScore = weeklyProgress[6];
      int growth = todayScore - yesterdayScore;

      transaction.update(docRef, {
        'weeklyProgress': weeklyProgress,
        'weeklyGrowth': growth,
        'dailyCorrect': dailyCorrect,
        'dailyTotal': dailyTotal,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
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
