import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:read_quest/screens/view/stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _HomeTab(),
    Center(child: Text("Read Page")),
    Center(child: Text("Rewards Page")),
    StatsTab(),
  ];

  void _onTap(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: const Color(0xFF2078FC),
        unselectedItemColor: const Color(0xFF999BA0),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Read"),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Rewards",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  int _asInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return fallback;
  }

  String _asString(dynamic v, {String fallback = ""}) {
    if (v == null) return fallback;
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const SafeArea(child: Center(child: Text("Not logged in.")));
    }

    final stream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: stream,
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

        // Values from Firestore
        final String username = _asString(data["username"], fallback: "User");
        final int level = _asInt(data["level"], fallback: 0);
        final int streak = _asInt(data["streak"], fallback: 0);

        final int currentXp = _asInt(data["currentXp"], fallback: 0);
        final int targetXp = _asInt(data["targetXp"], fallback: 2000);

        final int totalXpEarned = _asInt(data["totalXpEarned"], fallback: 0);
        final int badgesWon = _asInt(data["badgesWon"], fallback: 0);

        final int streakDays = _asInt(data["streakDays"], fallback: 0);
        final int wordsLearned = _asInt(data["wordsLearned"], fallback: 0);

        final String stageTitle = _asString(
          data["currentStageTitle"],
          fallback: "Stage title",
        );

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),

                // Top header row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const ReadQuestLogo(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: UserGreeting(username: username, level: level),
                      ),
                      StreakBadge(streak: streak),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // XP Progress
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: XpProgressBar(
                    currentXp: currentXp,
                    targetXp: targetXp,
                  ),
                ),

                const SizedBox(height: 14),

                // Start Quest card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: StartQuestCard(
                    stageTitle: stageTitle,
                    onTap: () {
                      debugPrint("Start Quest tapped");
                      // TODO: Navigator.push to your reading/quest screen
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // Two stat cards row
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

                // My Progress section
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

//

class ReadQuestLogo extends StatelessWidget {
  const ReadQuestLogo({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;

      // Navigate back to Login (change route if needed)
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: "Menu",
      offset: const Offset(0, 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) async {
        switch (value) {
          case 'logout':
            await _confirmLogout(context);
            break;
          case 'profile':
            // TODO: Navigate to profile screen later
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile (coming soon)")),
            );
            break;
          case 'settings':
            // TODO: Navigate to settings screen later
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Settings (coming soon)")),
            );
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'profile',
          child: ListTile(
            dense: true,
            leading: Icon(Icons.person),
            title: Text("Profile"),
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: ListTile(
            dense: true,
            leading: Icon(Icons.settings),
            title: Text("Settings"),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: ListTile(
            dense: true,
            leading: Icon(Icons.logout),
            title: Text("Logout"),
          ),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [_LogoImage(), SizedBox(height: 2)],
      ),
    );
  }
}

class _LogoImage extends StatelessWidget {
  const _LogoImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/read_quest_logo_splash.png", height: 65);
  }
}

class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 39,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        border: Border.all(color: const Color(0xFFDC7C52), width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$streak',
            style: const TextStyle(
              color: Color(0xFFFF6900),
              fontSize: 16,
              fontFamily: 'Mojangles',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Streak',
            style: TextStyle(
              color: Color(0xFFFF6900),
              fontSize: 16,
              fontFamily: 'Mojangles',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class UserGreeting extends StatelessWidget {
  final String username;
  final int level;

  const UserGreeting({super.key, required this.username, required this.level});

  String getLevelTitle(int level) {
    if (level == 0) return "Newbie";
    if (level < 5) return "Reader";
    if (level < 10) return "Scholar";
    return "Master";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, $username!',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Level $level ${getLevelTitle(level)}',
          style: const TextStyle(
            color: Color(0xFF00ACF6),
            fontSize: 14,
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class XpProgressBar extends StatelessWidget {
  final int currentXp;
  final int targetXp;

  const XpProgressBar({
    super.key,
    required this.currentXp,
    required this.targetXp,
  });

  String _formatNumber(int n) {
    final s = n.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final reverseIndex = s.length - i;
      buffer.write(s[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = targetXp == 0
        ? 0
        : (currentXp / targetXp).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          children: [
            const Text(
              'XP Progress',
              style: TextStyle(
                color: Color(0xFF8B8B8B),
                fontSize: 14,
                fontFamily: 'Maname',
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Text(
              '${_formatNumber(currentXp)}/${_formatNumber(targetXp)} XP',
              style: const TextStyle(
                color: Color(0xFF8B8B8B),
                fontSize: 14,
                fontFamily: 'Maname',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(18.5),
          child: Container(
            height: 13,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              borderRadius: BorderRadius.circular(18.5),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B7FFF),
                      borderRadius: BorderRadius.circular(18.5),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class StartQuestCard extends StatelessWidget {
  final String stageTitle;
  final VoidCallback onTap;

  const StartQuestCard({
    super.key,
    required this.stageTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.00, 0.50),
            end: Alignment(1.00, 0.50),
            colors: [Color(0xFF185AFA), Color(0xFF353BE2)],
          ),
          borderRadius: BorderRadius.circular(21),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFB0F0FF),
              blurRadius: 23.80,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFF5170F2),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: const Color(0xFF7D96FF), width: 1),
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Quest',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Continue: "$stageTitle"',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;

  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 32,
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class MyProgressSection extends StatelessWidget {
  final int currentLevel;
  final int streakDays;
  final int wordsLearned;

  const MyProgressSection({
    super.key,
    required this.currentLevel,
    required this.streakDays,
    required this.wordsLearned,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Progress',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        ProgressListItem(
          title: 'Current Level',
          valueText: '$currentLevel',
          pillBg: const Color(0xFFDBEAFE),
          valueColor: const Color(0xFF432DD7),
          valueFontSize: 18,
        ),
        const SizedBox(height: 14),
        ProgressListItem(
          title: 'Reading Streak',
          valueText: '$streakDays days',
          pillBg: const Color(0xFFFFEDD4),
          valueColor: const Color(0xFFCD681F),
          valueFontSize: 14,
        ),
        const SizedBox(height: 14),
        ProgressListItem(
          title: 'Words Learned',
          valueText: '$wordsLearned',
          pillBg: const Color(0xFFDBEAFE),
          valueColor: const Color(0xFF432DD7),
          valueFontSize: 18,
        ),
      ],
    );
  }
}

class ProgressListItem extends StatelessWidget {
  final String title;
  final String valueText;

  final Color pillBg;
  final Color valueColor;
  final double valueFontSize;

  const ProgressListItem({
    super.key,
    required this.title,
    required this.valueText,
    required this.pillBg,
    required this.valueColor,
    required this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 71,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFFE2E2E2), width: 2),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4F4F4F),
              fontSize: 18,
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(10.5),
            ),
            child: Text(
              valueText,
              style: TextStyle(
                color: valueColor,
                fontSize: valueFontSize,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
