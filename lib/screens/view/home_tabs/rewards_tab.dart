import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_quest/screens/widgets/menu_header.dart';
import 'package:read_quest/screens/widgets/rewards/daily_challenge_card.dart';
import 'package:read_quest/screens/widgets/rewards/rewards_badge.dart';
import 'package:read_quest/screens/widgets/rewards/rewards_progress_card.dart';
import 'package:read_quest/styles/app_colors.dart';
import 'package:read_quest/styles/app_spacings.dart';

class RewardsTab extends StatelessWidget {
  const RewardsTab({super.key});

  bool _isToday(Timestamp? timestamp) {
    if (timestamp == null) return false;

    final now = DateTime.now();
    final date = timestamp.toDate();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  int _countCompletedReadings(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return docs.where((doc) => doc.data()['isCompleted'] == true).length;
  }

  int _countTodayCompletedReadings(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return docs.where((doc) {
      final data = doc.data();
      final isCompleted = data['isCompleted'] == true;
      final completedAt = data['completedAt'] as Timestamp?;
      return isCompleted && _isToday(completedAt);
    }).length;
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(child: Text('Not logged in.')),
        ),
      );
    }

    final userDocStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots();

    final progressStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('progress')
        .snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userDocStream,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: SafeArea(
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (userSnapshot.hasError) {
          return Scaffold(
            body: SafeArea(
              child: Center(child: Text('Error: ${userSnapshot.error}')),
            ),
          );
        }

        final userData = userSnapshot.data?.data() ?? {};

        final int level = (userData['level'] as num?)?.toInt() ?? 0;
        final int currentXp = (userData['currentXp'] as num?)?.toInt() ?? 0;
        final int targetXp = (userData['targetXp'] as num?)?.toInt() ?? 2000;
        final int totalXpEarned = (userData['totalXpEarned'] as num?)?.toInt() ?? 0;
        final int comprehension = (userData['comprehension'] as num?)?.toInt() ?? 0;
        final int vocabulary = (userData['vocabulary'] as num?)?.toInt() ?? 0;
        final int readingSpeed = (userData['readingSpeed'] as num?)?.toInt() ?? 0;
        final int streakDays = (userData['streakDays'] as num?)?.toInt() ?? 0;

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: progressStream,
          builder: (context, progressSnapshot) {
            if (progressSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: SafeArea(
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            if (progressSnapshot.hasError) {
              return Scaffold(
                body: SafeArea(
                  child: Center(child: Text('Error: ${progressSnapshot.error}')),
                ),
              );
            }

            final progressDocs = progressSnapshot.data?.docs ?? [];

            final int completedReadings = _countCompletedReadings(progressDocs);
            final int todayCompleted = _countTodayCompletedReadings(progressDocs);

            final badges = [
              {
                'title': 'EAGLE EYE',
                'color': const Color(0xFFFFC107),
                'icon': Icons.military_tech,
                'isLocked': comprehension < 10,
              },
              {
                'title': 'SPEED READER',
                'color': const Color(0xFF42A5F5),
                'icon': Icons.bolt,
                'isLocked': readingSpeed < 10,
              },
              {
                'title': 'VOCAB MASTER',
                'color': const Color(0xFFAB47BC),
                'icon': Icons.star_border,
                'isLocked': vocabulary < 10,
              },
              {
                'title': 'PERSISTENT',
                'color': const Color(0xFF4CAF50),
                'icon': Icons.shield,
                'isLocked': streakDays < 3,
              },
              {
                'title': 'BOOKWORM',
                'color': const Color(0xFF8BC34A),
                'icon': Icons.menu_book,
                'isLocked': completedReadings < 3,
              },
              {
                'title': 'KIND SOUL',
                'color': const Color(0xFFE91E63),
                'icon': Icons.favorite,
                'isLocked': totalXpEarned < 1000,
              },
            ];

            return Scaffold(
              backgroundColor: AppColors.homeBackground,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: AppSpacings.homeTabPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MenuHeader(
                        headerText: 'Reading Rewards',
                        subHeaderText: 'Collect badges and unlock new quests',
                      ),
                      const SizedBox(height: 24),

                      RewardsProgressCard(
                        level: level,
                        currentXp: currentXp,
                        targetXp: targetXp,
                        totalXpEarned: totalXpEarned,
                      ),

                      const SizedBox(height: 32),
                      _buildSectionTitle('My Badges'),
                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 16,
                        runSpacing: 20,
                        alignment: WrapAlignment.start,
                        children: badges.map((badge) {
                          return RewardsBadge(
                            context: context,
                            title: badge['title'] as String,
                            color: badge['color'] as Color,
                            icon: badge['icon'] as IconData,
                            isLocked: badge['isLocked'] as bool,
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 32),
                      _buildSectionTitle('Daily Challenges'),
                      const SizedBox(height: 16),

                      Column(
                        children: [
                          DailyChallengeCard(
                            title: 'Complete 2 Quests',
                            reward: '+100 XP REWARD',
                            progress: '${todayCompleted.clamp(0, 2)}/2',
                            icon: Icons.bolt,
                            iconColor: Colors.blue,
                          ),
                          const SizedBox(height: 12),
                          DailyChallengeCard(
                            title: 'Complete 5 Quests',
                            reward: '+250 XP REWARD',
                            progress: '${todayCompleted.clamp(0, 5)}/5',
                            icon: Icons.bolt,
                            iconColor: Colors.blue,
                          ),
                          const SizedBox(height: 12),
                          DailyChallengeCard(
                            title: 'Complete 10 Quests',
                            reward: '+500 XP REWARD',
                            progress: '${todayCompleted.clamp(0, 10)}/10',
                            icon: Icons.bolt,
                            iconColor: Colors.blue,
                          ),
                          const SizedBox(height: 12),
                          DailyChallengeCard(
                            title: 'Complete 20 Quests',
                            reward: '+1000 XP REWARD',
                            progress: '${todayCompleted.clamp(0, 20)}/20',
                            icon: Icons.bolt,
                            iconColor: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}