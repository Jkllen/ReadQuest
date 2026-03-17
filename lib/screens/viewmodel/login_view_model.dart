import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:read_quest/services/auth_services.dart';

class LoginViewModel extends ChangeNotifier {
  String email = '';
  String password = '';
  bool loading = false;

  String get isEmail => email;
  String get isPassword => password;
  bool get isLoading => loading;

  void setEmail(String value) {
    email = value.trim();
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  Future<String?> login() async {
    if (email.isEmpty || password.isEmpty) {
      return 'Please fill in all fields';
    }

    loading = true;
    notifyListeners();

    try {
      final user = await AuthService().login(
        email: email,
        password: password,
      );

      if (user == null) {
        return 'Login failed. Please try again.';
      }

      return null; 
    } on FirebaseAuthException catch (e) {
      return switch (e.code) {
        'user-not-found' => 'No account found for that email.',
        'wrong-password' => 'Wrong password.',
        'invalid-email' => 'Invalid email format.',
        _ => 'Login failed: ${e.message}',
      };
    } catch (e) {
      return 'Login failed: $e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}