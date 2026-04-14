import 'package:flutter/material.dart';

class AppPalette {
  const AppPalette();

  static const white = Color(0xffeeeff5);
  static const brown = Color(0xFf454135);
  static const black = Color(0xFF1e1e1f);

  static const aqua = Color(0xFF46B5C8);
  static const blue =  Color(0xFF8591c1);
  static const green = Color(0xffb5ca8d);
  static const red = Color(0xFFff858d);
  static const yellow = Color(0xFFffc857);
}

class AppColors {
  static const homeBackground = Color(0xFFF9FAFB);
  static const navigationBar = AppPalette.black;
  static const accent = Color(0xFF2078FC);

  static const card = _CardColors();

  static const home = _HomeColors();
  static const difficulty = _DifficultyColors();
  static const rewards = _RewardsColors();
  static const stats = _StatsColors();
  static const quiz = _QuizColors();
  static const boss = _BossColors();
}

class _CardColors {
  const _CardColors();

  final text = Colors.white;
  final subtext = Colors.white70;
  final subtext2 = Colors.white54;

  final icon = Colors.white;
  final iconBackground = Colors.white24;
}

class _HomeColors {
  const _HomeColors();

  final xpCard = AppPalette.blue;
  final badgeCard = AppPalette.green;
  final levelCard = AppPalette.red;
  final streakCard = AppPalette.yellow;
  final wordsCard = AppPalette.aqua;
}

class _DifficultyColors {
  const _DifficultyColors();

  final easy = const Color(0xFF05DF72);
  final medium = const Color(0xFFFDC700);
  final hard = const Color(0xFFDF0505);
}

class _RewardsColors {
  const _RewardsColors();

  // TODO: Move rewards colors here
}

class _StatsColors {
  const _StatsColors();

  final positiveGrowth = const Color(0xFF10B981);
  final negativeGrowth = const Color(0xFFB9103A);

  final comprehensionCard = const Color(0xFF3B82F6);
  final vocabularyCard = const Color(0xFFA855F7);
  final speedCard = const Color(0xFFB9A210);
}

class _QuizColors {
  const _QuizColors();

  final correct = const Color(0xFF22C55E);
  final incorrect = const Color(0xFFEF4444);
}

class _BossColors {
  const _BossColors();

  final bgStartColor = const Color(0xFF160A34);
  final bgEndColor = const Color(0xFF2A1054);
  final cardColor = const Color(0xFF1C1337);
  final heroBlue = const Color(0xFF4A67E2);
  final bossMagenta = const Color(0xFFD61868);
  final attackTimer = Colors.amber;
}
