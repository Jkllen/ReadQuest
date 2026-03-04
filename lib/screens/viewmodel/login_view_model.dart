import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String _username = '';
  String _password = '';
  bool _isLoading = false;

  String get username => _username;
  String get password => _password;
  bool get isLoading => _isLoading;

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (_username.isEmpty || _password.isEmpty) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Simulate login delay
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login Successful!')),
    );
  }
}