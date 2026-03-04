import 'package:flutter/material.dart';
import 'package:read_quest/services/user_services.dart';
import 'package:read_quest/services/auth_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReadQuest Home'),
        backgroundColor: const Color(0xFF155DFC),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: UserService().getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final username = snapshot.data ?? 'Reader';
            return Text(
              'Welcome, $username!',
              style: const TextStyle(fontSize: 22),
            );
          },
        ),
      ),
    );
  }
}