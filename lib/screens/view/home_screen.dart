import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:read_quest/widgets/home/my_progress_section.dart';
import 'package:read_quest/widgets/home/start_quest_card.dart';
import 'package:read_quest/widgets/home/stat_card.dart';
import 'package:read_quest/widgets/home/streak_badge.dart';
import 'package:read_quest/widgets/home/user_greeting.dart';
import 'package:read_quest/widgets/home/xp_progress_bar.dart';

// import 'package:read_quest/widgets/home/';

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
    Center(child: Text("Stats Page")),
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
