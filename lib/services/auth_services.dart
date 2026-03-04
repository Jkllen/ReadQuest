import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register
  Future<User?> registerWithEmail(String email, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndUsername(
          email: email, username: username);
      return result.user;
    } catch (e) {
      debugPrint("Register Error: $e");
      return null;
    }
  }

  // Login
  Future<User?> loginWithEmail(String email, String username) async {
    try {
      UserCredential result =
          await _auth.signInWithUsername(username: username);
      return result.user;
    } catch (e) {
      debugPrint("Login Error: $e");
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Current User
  User? get currentUser => _auth.currentUser;
}