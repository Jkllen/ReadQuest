import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> register({
    required String email,
    required String password,
    required String username,
  }) async {

    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = cred.user;
    if (user == null) return null;

    // Create user profile in Firestore
    await _db.collection('users').doc(user.uid).set({
      "email": email.trim(),
      "username": username.trim(),

      // GAME DATA
      "level": 0,
      "streak": 0,
      "currentXp": 0,
      "targetXp": 2000,
      "totalXpEarned": 0,
      "badgesWon": 0,
      "streakDays": 0,
      "wordsLearned": 0,

      // QUEST
      "currentStageTitle": "Stage 1",

      // METADATA
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),

    }, SetOptions(merge: true));

    return user;
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    return cred.user;
  }

  Future<void> logout() => _auth.signOut();

  User? get currentUser => _auth.currentUser;
}