import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<User?> register({
    required String email,
    required String password,
    required String username,
  }) async {

    final cred = await auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = cred.user;
    if (user == null) return null;

    // Create user profile in Firestore
    await db.collection('users').doc(user.uid).set({
      "email": email.trim(),
      "username": username.trim(),

      // Game Data
      "level": 0,
      "streak": 0,
      "currentXp": 0,
      "targetXp": 2000,
      "totalXpEarned": 0,
      "badgesWon": 0,
      "streakDays": 0,
      "wordsLearned": 0,

      // Quest
      "currentStageTitle": "Stage 1",

      // Metadata
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),

    }, SetOptions(merge: true));

    return user;
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    final cred = await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    return cred.user;
  }

  Future<void> logout() => auth.signOut();

  User? get currentUser => auth.currentUser;
}