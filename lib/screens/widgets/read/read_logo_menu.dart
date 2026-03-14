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
      child: const Text(
        'READ QUEST',
        style: TextStyle(
          color: Color(0xFF111391),
          fontSize: 9,
          fontFamily: 'Mojangles',
        ),
      ),
    );
  }
}