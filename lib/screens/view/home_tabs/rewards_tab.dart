import 'package:flutter/material.dart';
import 'package:read_quest/screens/widgets/menu_header.dart';
import 'package:read_quest/screens/widgets/rewards/daily_challenge_card.dart';
import 'package:read_quest/screens/widgets/rewards/rewards_badge.dart';
import 'package:read_quest/screens/widgets/rewards/rewards_progress_card.dart';
import 'package:read_quest/styles/app_colors.dart';
import 'package:read_quest/styles/app_spacings.dart';

class RewardsTab extends StatelessWidget {
  const RewardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacings.homeTabPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MenuHeader(
                headerText: 'Reading Rewards',
                subHeaderText: 'Collect badges and unlock new quests',
              ),
              const SizedBox(height: 24),
              RewardsProgressCard(),
              const SizedBox(height: 32),
              _buildSectionTitle('My Badges'),
              const SizedBox(height: 16),
              _buildBadgesGrid(context),
              const SizedBox(height: 32),
              _buildSectionTitle('Daily Challenges'),
              const SizedBox(height: 16),
              Column(
                spacing: 12.0,
                children: [
                  DailyChallengeCard(
                    title: 'Complete 2 Quests',
                    reward: '+100 XP REWARD',
                    progress: '0/2',
                    icon: Icons.bolt,
                    iconColor: Colors.blue,
                  ),
                  DailyChallengeCard(
                    title: 'Complete 5 Quests',
                    reward: '+250 XP REWARD',
                    progress: '0/5',
                    icon: Icons.bolt,
                    iconColor: Colors.blue,
                  ),
                  DailyChallengeCard(
                    title: 'Complete 10 Quests',
                    reward: '+500 XP REWARD',
                    progress: '0/10',
                    icon: Icons.bolt,
                    iconColor: Colors.blue,
                  ),
                  DailyChallengeCard(
                    title: 'Complete 20 Quests',
                    reward: '+1000 XP REWARD',
                    progress: '0/20',
                    icon: Icons.bolt,
                    iconColor: Colors.blue,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
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

  Widget _buildBadgesGrid(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 20,
      alignment: WrapAlignment.start,
      children: [
        RewardsBadge(
          context: context,
          title: 'EAGLE EYE',
          color: const Color(0xFFFFC107),
          icon: Icons.military_tech,
          isLocked: false,
        ),
        RewardsBadge(
          context: context,
          title: 'SPEED READER',
          color: const Color(0xFF42A5F5),
          icon: Icons.bolt,
          isLocked: false,
        ),
        RewardsBadge(
          context: context,
          title: 'VOCAB MASTER',
          color: const Color(0xFFAB47BC),
          icon: Icons.star_border,
          isLocked: false,
        ),
        RewardsBadge(
          context: context,
          title: 'PERSISTENT',
          color: Colors.grey.shade200,
          icon: Icons.shield,
          isLocked: true,
        ),
        RewardsBadge(
          context: context,
          title: 'BOOKWORM',
          color: Colors.grey.shade200,
          icon: Icons.menu_book,
          isLocked: true,
        ),
        RewardsBadge(
          context: context,
          title: 'KIND SOUL',
          color: Colors.grey.shade200,
          icon: Icons.favorite,
          isLocked: true,
        ),
      ],
    );
  }
}
