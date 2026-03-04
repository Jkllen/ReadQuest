import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

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
  
}