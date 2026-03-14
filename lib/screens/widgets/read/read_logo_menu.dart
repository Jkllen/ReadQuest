import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReadQuestLogoMenu extends StatelessWidget {
  const ReadQuestLogoMenu({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          _logout(context);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
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