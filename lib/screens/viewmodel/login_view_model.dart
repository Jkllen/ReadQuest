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

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(
      r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(value);
  }

  Future<String?> login() async {
    if (loading) return 'Login is already in progress.';

    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty && password.isEmpty) {
      return 'Please enter your email and password.';
    }

    if (trimmedEmail.isEmpty) {
      return 'Please enter your email.';
    }

    if (password.isEmpty) {
      return 'Please enter your password.';
    }

    if (!_isValidEmail(trimmedEmail)) {
      return 'Please enter a valid email address.';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }

    loading = true;
    notifyListeners();

    try {
      final user = await AuthService().login(
        email: trimmedEmail,
        password: password,
      );

      if (user == null) {
        return 'Login failed. Please try again.';
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return switch (e.code) {
        'user-not-found' => 'No account found for that email.',
        'wrong-password' => 'Incorrect password.',
        'invalid-email' => 'Invalid email format.',
        'invalid-credential' => 'Invalid email or password.',
        'too-many-requests' => 'Too many attempts. Please try again later.',
        'user-disabled' => 'This account has been disabled.',
        _ => 'Login failed. Please try again.',
      };
    } catch (_) {
      return 'Something went wrong. Please try again.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}