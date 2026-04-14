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
      "targetXp": 100,
      "totalXpEarned": 0,
      "badgesWon": 0,
      "streakDays": 0,
      "wordsLearned": 0,
      "currentStageTitle": "Stage title",

      // Stats screen fields
      "comprehension": 0,
      "vocabulary": 0,
      "readingSpeed": 0,
      "readingSessions": 0,
      "readingSpeedTotal": 0,
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

  Future<String> _todayRewardDocId() async {
    final now = DateTime.now();
    final yyyy = now.year.toString().padLeft(4, '0');
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd';
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> dailyRewardsStream() async* {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      yield* const Stream.empty();
      return;
    }

    final docId = await _todayRewardDocId();

    yield* _db
        .collection('users')
        .doc(uid)
        .collection('daily_rewards')
        .doc(docId)
        .snapshots();
  }

  Future<bool> claimDailyReward({
    required String challengeKey,
    required int xpReward,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    final docId = await _todayRewardDocId();

    final rewardRef = _db
        .collection('users')
        .doc(uid)
        .collection('daily_rewards')
        .doc(docId);

    final snapshot = await rewardRef.get();
    final data = snapshot.data() ?? {};

    if (data[challengeKey] == true) {
      return false;
    }

    await rewardRef.set({
      challengeKey: true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await addQuizRewards(xpAmount: xpReward);

    return true;
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

    await refreshBadgesWon();
  }

  Future<void> updateReadingSpeed({required int readingSpeed}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).set({
      "readingSpeed": readingSpeed,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await refreshBadgesWon();
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

  Future<void> updateBadgesWon({
    required int comprehension,
    required int vocabulary,
    required int readingSpeed,
    required int streakDays,
    required int completedReadings,
    required int totalXpEarned,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    int badgesWon = 0;

    if (comprehension >= 10) badgesWon++;
    if (readingSpeed >= 10) badgesWon++;
    if (vocabulary >= 10) badgesWon++;
    if (streakDays >= 3) badgesWon++;
    if (completedReadings >= 3) badgesWon++;
    if (totalXpEarned >= 1000) badgesWon++;

    await _db.collection('users').doc(uid).set({
      "badgesWon": badgesWon,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<int> getCompletedReadingsCount() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 0;

    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('progress')
        .where('isCompleted', isEqualTo: true)
        .get();

    return snapshot.docs.length;
  }

  Future<void> refreshBadgesWon() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = await _db.collection('users').doc(uid).get();
    final data = doc.data() ?? {};

    final completedReadings = await getCompletedReadingsCount();

    await updateBadgesWon(
      comprehension: (data['comprehension'] as num?)?.toInt() ?? 0,
      vocabulary: (data['vocabulary'] as num?)?.toInt() ?? 0,
      readingSpeed: (data['readingSpeed'] as num?)?.toInt() ?? 0,
      streakDays: (data['streakDays'] as num?)?.toInt() ?? 0,
      completedReadings: completedReadings,
      totalXpEarned: (data['totalXpEarned'] as num?)?.toInt() ?? 0,
    );
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

    final userRef = _db.collection('users').doc(uid);
    final snapshot = await userRef.get();
    final data = snapshot.data() ?? {};

    final int oldTotalXp = (data['totalXpEarned'] as num?)?.toInt() ?? 0;
    final int newTotalXp = oldTotalXp + xpAmount;

    final levelData = _calculateLevelData(newTotalXp);

    await userRef.set({
      "level": levelData.level,
      "currentXp": levelData.currentXp,
      "targetXp": levelData.targetXp,
      "totalXpEarned": newTotalXp,
      "wordsLearned": FieldValue.increment(wordsLearnedAmount),
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await refreshBadgesWon();
  }

  _LevelData _calculateLevelData(int totalXp) {
    int level = 0;
    int xpRemaining = totalXp;
    int targetXp = _xpNeededForLevel(level);

    while (xpRemaining >= targetXp) {
      xpRemaining -= targetXp;
      level++;
      targetXp = _xpNeededForLevel(level);
    }

    return _LevelData(level: level, currentXp: xpRemaining, targetXp: targetXp);
  }

  int _xpNeededForLevel(int level) {
    return (level + 1) * 100;
  }

  Future<void> updateReadingStatsOnCompletion({
    required String readingId,
    required String content,
    required DateTime startedAt,
    required DateTime completedAt,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userRef = _db.collection('users').doc(uid);
    final snapshot = await userRef.get();
    final data = snapshot.data() ?? {};

    final durationMinutes = completedAt.difference(startedAt).inSeconds / 60;

    final safeMinutes = durationMinutes <= 0 ? 1 : durationMinutes;

    final wordCount = content
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;

    final int sessionWpm = (wordCount / safeMinutes).round();

    final int oldReadingSessions =
        (data['readingSessions'] as num?)?.toInt() ?? 0;
    final int oldReadingSpeedTotal =
        (data['readingSpeedTotal'] as num?)?.toInt() ?? 0;

    final int newReadingSessions = oldReadingSessions + 1;
    final int newReadingSpeedTotal = oldReadingSpeedTotal + sessionWpm;
    final int averageWpm = (newReadingSpeedTotal / newReadingSessions).round();

    await userRef.set({
      "readingSpeed": averageWpm,
      "readingSessions": newReadingSessions,
      "readingSpeedTotal": newReadingSpeedTotal,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _updateDailyStreak(completedAt: completedAt);
    await refreshBadgesWon();
  }

  Future<void> _updateDailyStreak({required DateTime completedAt}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userRef = _db.collection('users').doc(uid);
    final snapshot = await userRef.get();
    final data = snapshot.data() ?? {};

    final Timestamp? lastActiveTimestamp = data['lastActiveDate'] as Timestamp?;
    final int currentStreak = (data['streakDays'] as num?)?.toInt() ?? 0;

    final today = DateTime(
      completedAt.year,
      completedAt.month,
      completedAt.day,
    );

    if (lastActiveTimestamp == null) {
      await userRef.set({
        "streakDays": 1,
        "streak": 1,
        "lastActiveDate": Timestamp.fromDate(today),
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }

    final lastActive = lastActiveTimestamp.toDate();
    final lastDay = DateTime(lastActive.year, lastActive.month, lastActive.day);

    final difference = today.difference(lastDay).inDays;

    if (difference == 0) {
      return;
    }

    if (difference == 1) {
      final newStreak = currentStreak + 1;

      await userRef.set({
        "streakDays": newStreak,
        "streak": newStreak,
        "lastActiveDate": Timestamp.fromDate(today),
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    }

    await userRef.set({
      "streakDays": 1,
      "streak": 1,
      "lastActiveDate": Timestamp.fromDate(today),
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

class _LevelData {
  final int level;
  final int currentXp;
  final int targetXp;

  _LevelData({
    required this.level,
    required this.currentXp,
    required this.targetXp,
  });
}
