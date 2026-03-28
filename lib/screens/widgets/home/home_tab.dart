import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_quest/screens/widgets/home/my_progress_section.dart';
import 'package:read_quest/screens/widgets/home/start_quest_card.dart';
import 'package:read_quest/screens/widgets/home/stat_card.dart';
import 'package:read_quest/screens/widgets/home/home_header.dart';
import 'package:read_quest/screens/widgets/home/xp_progress_bar.dart';
import 'package:read_quest/styles/app_colors.dart';
import 'package:read_quest/styles/app_spacings.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onOpenReadTab;

  const HomeTab({super.key, required this.onOpenReadTab});

  int asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return fallback;
  }

  String asString(dynamic value, {String fallback = ""}) {
    if (value == null) return fallback;
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const SafeArea(child: Center(child: Text("Not logged in.")));
    }

    final userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SafeArea(
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SafeArea(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data?.data();

        if (data == null) {
          return const SafeArea(
            child: Center(child: Text("User profile not found in Firestore.")),
          );
        }

        final String username = asString(data["username"], fallback: "User");
        final int level = asInt(data["level"], fallback: 0);
        final int streak = asInt(data["streak"], fallback: 0);

        final int currentXp = asInt(data["currentXp"], fallback: 0);
        final int targetXp = asInt(data["targetXp"], fallback: 2000);

        final int totalXpEarned = asInt(data["totalXpEarned"], fallback: 0);
        final int badgesWon = asInt(data["badgesWon"], fallback: 0);

        final int streakDays = asInt(data["streakDays"], fallback: 0);
        final int wordsLearned = asInt(data["wordsLearned"], fallback: 0);

        return HomePage(
          username: username,
          level: level,
          streak: streak,
          currentXp: currentXp,
          targetXp: targetXp,
          onOpenReadTab: onOpenReadTab,
          totalXpEarned: totalXpEarned,
          badgesWon: badgesWon,
          streakDays: streakDays,
          wordsLearned: wordsLearned,
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.username,
    required this.level,
    required this.streak,
    required this.currentXp,
    required this.targetXp,
    required this.onOpenReadTab,
    required this.totalXpEarned,
    required this.badgesWon,
    required this.streakDays,
    required this.wordsLearned,
  });

  final String username;
  final int level;
  final int streak;
  final int currentXp;
  final int targetXp;
  final VoidCallback onOpenReadTab;
  final int totalXpEarned;
  final int badgesWon;
  final int streakDays;
  final int wordsLearned;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              HomeHeader(username: username, level: level, streak: streak),
              const SizedBox(height: 14),
              XpProgressBar(currentXp: currentXp, targetXp: targetXp),
              const SizedBox(height: 14),
              StartQuestCard(onOpenReadTab: onOpenReadTab),
              const SizedBox(height: 14),
              Row(
                children: [
                  StatCard(
                    value: "$totalXpEarned",
                    label: "Total XP Earned",
                    accentColor: const Color(0xFF8200DB),
                  ),
                  const SizedBox(width: AppSpacings.betweenItems),
                  StatCard(
                    value: "$badgesWon",
                    label: "Badges Won",
                    accentColor: const Color(0xFF1E914E),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacings.section),
              MyProgressSection(
                currentLevel: level,
                streakDays: streakDays,
                wordsLearned: wordsLearned,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
