import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const ReadQuestApp());
}

class ReadQuestApp extends StatelessWidget {
  const ReadQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReadQuest',
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}