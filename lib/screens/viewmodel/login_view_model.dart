import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:read_quest/services/auth_services.dart';

class LoginViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;

  void setEmail(String value) {
    _email = value.trim();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<String?> login() async {
    if (_email.isEmpty || _password.isEmpty) {
      return 'Please fill in all fields';
    }

    _isLoading = true;
    notifyListeners();

    try {
      final user = await AuthService().login(
        email: _email,
        password: _password,
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
      _isLoading = false;
      notifyListeners();
    }
  }
}