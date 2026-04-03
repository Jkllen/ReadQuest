import 'package:flutter/material.dart';

class AppColors {
  static const homeBackground = Color(0xFFF9FAFB);
  static const accent = Color(0xFF2078FC);

  static const home = _HomeColors();
  static const read = _ReadColors();
  static const difficulty = _DifficultyColors();
  static const rewards = _RewardsColors();
  static const stats = _StatsColors();
  static const quiz = _QuizColors();
  static const boss = _BossColors();
}

class _HomeColors {
  const _HomeColors();

  final xpCard = const Color(0xFF7C3AED);
  final badgeCard = const Color(0xFF34D399);
  final levelCard = const Color(0xFF432DD7);
  final streakCard = const Color(0xFFF97316);
  final wordsCard = const Color(0xFF432DD7);
}

class _ReadColors {
  const _ReadColors();
  final easy = const Color(0xFF05DF72);
  final medium = const Color(0xFFFDC700);
  final hard = const Color(0xFFDF0505);
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

  final positiveGrowth = const Color(0xFF22C55E);
  final negativeGrowth = const Color(0xFFEF4444);

  final comprehensionCard = const Color(0xFF3B82F6);
  final vocabularyCard = const Color(0xFFA855F7);
  final speedCard = const Color(0xFF10B981);
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
