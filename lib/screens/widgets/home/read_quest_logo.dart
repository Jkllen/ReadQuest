import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReadQuestLogo extends StatelessWidget {
  const ReadQuestLogo({super.key});

  Future<void> confirmLogout(BuildContext context) async {
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

      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: "Menu",
      offset: const Offset(0, 60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) async {
        switch (value) {
          case 'logout':
            await confirmLogout(context);
            break;
          case 'profile':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Will not add")),
            );
            break;
          case 'settings':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Will not add")),
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
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LogoImage(),
          SizedBox(height: 2),
        ],
      ),
    );
  }
}

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/read_quest_logo_splash.png",
      height: 65,
    );
  }
}