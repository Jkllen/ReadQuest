import 'package:flutter/material.dart';
import 'package:read_quest/screens/widgets/logo_menu.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), 
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450), 
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildProgressCard(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('My Badges'),
                  const SizedBox(height: 16),
                  _buildBadgesGrid(context),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Daily Challenges'),
                  const SizedBox(height: 16),
                  _buildDailyChallengeCard('Complete 2 Quests', '+100 XP REWARD', '0/2', Icons.bolt, Colors.blue),
                  const SizedBox(height: 12),
                  _buildDailyChallengeCard('Complete 5 Quests', '+250 XP REWARD', '0/5', Icons.bolt, Colors.blue),
                  const SizedBox(height: 12),
                  _buildDailyChallengeCard('Complete 10 Quests', '+500 XP REWARD', '0/10', Icons.bolt, Colors.blue),
                  const SizedBox(height: 12),
                  _buildDailyChallengeCard('Complete 20 Quests', '+1000 XP REWARD', '0/20', Icons.bolt, Colors.blue),
                  const SizedBox(height: 30), 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const ReadQuestLogoMenu(), 
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Reading Quests',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                ),
              ),
              Text(
                'Collect badges and unlock new quests',
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5B24E5), Color(0xFF9E65FF)], 
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B24E5).withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('TOTAL PROGRESS', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, letterSpacing: 1.2, fontSize: 12)),
                  Text('Lv. 0', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.1, 
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text('100 XP to Level 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('0\nTOTAL XP', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 20,
          top: 10,
          child: Icon(
            Icons.emoji_events, 
            size: 110, 
            color: Colors.white.withValues(alpha: 0.15), 
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildBadgesGrid(BuildContext context) {
    return Wrap(
      spacing: 16, 
      runSpacing: 20, 
      alignment: WrapAlignment.start,
      children: [
        _buildBadge(context, title: 'EAGLE EYE', color: const Color(0xFFFFC107), icon: Icons.military_tech, isLocked: false),
        _buildBadge(context, title: 'SPEED READER', color: const Color(0xFF42A5F5), icon: Icons.bolt, isLocked: false),
        _buildBadge(context, title: 'VOCAB MASTER', color: const Color(0xFFAB47BC), icon: Icons.star_border, isLocked: false),
        _buildBadge(context, title: 'PERSISTENT', color: Colors.grey.shade200, icon: Icons.shield, isLocked: true),
        _buildBadge(context, title: 'BOOKWORM', color: Colors.grey.shade200, icon: Icons.menu_book, isLocked: true),
        _buildBadge(context, title: 'KIND SOUL', color: Colors.grey.shade200, icon: Icons.favorite, isLocked: true),
      ],
    );
  }

  Widget _buildBadge(BuildContext context, {required String title, required Color color, required IconData icon, required bool isLocked}) {
    const double badgeSize = 88.0; 

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: badgeSize,
          height: badgeSize,
          decoration: BoxDecoration(
            color: isLocked ? const Color(0xFFF0F0F0) : color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white, width: 3), 
            boxShadow: [
              BoxShadow(
                color: isLocked ? Colors.grey.withValues(alpha: 0.1) : color.withValues(alpha: 0.4), 
                blurRadius: 10, 
                offset: const Offset(0, 4)
              )
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 36, color: isLocked ? Colors.grey.shade300 : Colors.white),
              if (isLocked)
                Icon(Icons.lock_outline, size: 24, color: Colors.grey.shade400),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: isLocked ? Colors.grey.shade400 : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyChallengeCard(String title, String reward, String progress, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1), 
              shape: BoxShape.circle
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(reward, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          Text(
            progress,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}