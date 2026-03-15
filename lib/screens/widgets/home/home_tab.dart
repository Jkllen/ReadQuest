import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_quest/screens/widgets/home/my_progress_section.dart';
import 'package:read_quest/screens/widgets/home/start_quest_card.dart';
import 'package:read_quest/screens/widgets/home/stat_card.dart';
import 'package:read_quest/screens/widgets/home/streak_badge.dart';
import 'package:read_quest/screens/widgets/home/user_greeting.dart';
import 'package:read_quest/screens/widgets/home/xp_progress_bar.dart';
import 'package:read_quest/screens/widgets/logo_menu.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

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
      return const SafeArea(
        child: Center(
          child: Text("Not logged in."),
        ),
      );
    }

    final userStream =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SafeArea(
            child: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SafeArea(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final data = snapshot.data?.data();

        if (data == null) {
          return const SafeArea(
            child: Center(
              child: Text("User profile not found in Firestore."),
            ),
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

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const ReadQuestLogoMenu(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: UserGreeting(
                          username: username,
                          level: level,
                        ),
                      ),
                      StreakBadge(streak: streak),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: XpProgressBar(
                    currentXp: currentXp,
                    targetXp: targetXp,
                  ),
                ),
                const SizedBox(height: 14),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: StartQuestCard(),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          value: "$totalXpEarned",
                          label: "Total XP Earned",
                          backgroundColor: const Color(0xFFFAF5FF),
                          borderColor: const Color(0xFFDEBEFF),
                          textColor: const Color(0xFF8200DB),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          value: "$badgesWon",
                          label: "Badges Won",
                          backgroundColor: const Color(0xFFF0FDF4),
                          borderColor: const Color(0xFFA3F5BC),
                          textColor: const Color(0xFF1E914E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MyProgressSection(
                    currentLevel: level,
                    streakDays: streakDays,
                    wordsLearned: wordsLearned,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}