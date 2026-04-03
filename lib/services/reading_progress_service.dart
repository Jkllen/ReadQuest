import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadingProgressService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ReadingProgressService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  String? get currentUserId => auth.currentUser?.uid;

  DocumentReference<Map<String, dynamic>> progressRef(String readingId) {
    final uid = currentUserId;
    if (uid == null) {
      throw Exception('User is not logged in.');
    }

    return firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc(readingId);
  }

  Future<Map<String, dynamic>?> getProgress(String readingId) async {
    final snapshot = await progressRef(readingId).get();
    return snapshot.data();
  }

  Future<void> createOrInitializeProgress({
    required String readingId,
    required String title,
    required int rewardXp,
  }) async {
    final ref = progressRef(readingId);
    final snapshot = await ref.get();
    final data = snapshot.data();

    if (!snapshot.exists) {
      await ref.set({
        'readingId': readingId,
        'title': title,
        'progress': 0.0,
        'isCompleted': false,
        'startedAt': FieldValue.serverTimestamp(),
        'completedAt': null,
        'updatedAt': FieldValue.serverTimestamp(),
        'rewardXp': rewardXp,
      });
      return;
    }

    await ref.set({
      'readingId': readingId,
      'title': title,
      'rewardXp': rewardXp,
      'startedAt': data?['startedAt'] ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveProgress({
    required String readingId,
    required String title,
    required double progress,
    required bool isCompleted,
    required int rewardXp,
  }) async {
    final normalizedProgress = progress.clamp(0.0, 1.0);

    final payload = <String, dynamic>{
      'readingId': readingId,
      'title': title,
      'progress': isCompleted ? 1.0 : normalizedProgress,
      'isCompleted': isCompleted,
      'rewardXp': rewardXp,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (isCompleted) {
      payload['completedAt'] = FieldValue.serverTimestamp();
    }

    await progressRef(readingId).set(payload, SetOptions(merge: true));
  }
}