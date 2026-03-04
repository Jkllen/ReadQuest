import 'dart:async';
import 'package:flutter/material.dart';

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
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }
}