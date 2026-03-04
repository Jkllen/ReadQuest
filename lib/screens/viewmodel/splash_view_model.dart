import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:read_quest/routes/app_routes.dart';

class SplashViewModel extends ChangeNotifier {
  double _progress = 0.0;
  double get progress => _progress;

  void startLoading(BuildContext context) {
    const totalDuration = Duration(seconds: 3);
    const interval = Duration(milliseconds: 50);

    int ticks = totalDuration.inMilliseconds ~/ interval.inMilliseconds;
    int currentTick = 0;

    Timer.periodic(interval, (timer) {
      currentTick++;
      _progress = currentTick / ticks;
      notifyListeners();

      if (currentTick >= ticks) {
        timer.cancel();

        if (!context.mounted) return;

        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      }
    });
  }
}