import 'package:flutter/material.dart';
import 'package:read_quest/screens/view/home_tabs/read_tab.dart';
import 'package:read_quest/screens/view/home_tabs/rewards_tab.dart';
import 'package:read_quest/screens/view/home_tabs/dashboard_tab.dart';
import 'package:read_quest/screens/view/home_tabs/stats_tab.dart';
import 'package:read_quest/styles/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  List<NavigationDestination> destinations = [
    NavigationDestination(
      icon: Icon(Icons.dashboard, color: Colors.white),
      label: "Dashboard",
    ),
    NavigationDestination(
      icon: Icon(Icons.menu_book, color: Colors.white),
      label: "Read",
    ),
    NavigationDestination(
      icon: Icon(Icons.card_giftcard, color: Colors.white),
      label: "Rewards",
    ),
    NavigationDestination(
      icon: Icon(Icons.bar_chart, color: Colors.white),
      label: "Stats",
    ),
  ];

  void onTap(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardTab(onOpenReadTab: () => onTap(1)),
      const ReadTab(),
      const RewardsTab(),
      const StatsTab(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        indicatorColor: const Color(0x33000000),
        backgroundColor: AppColors.accent,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        labelTextStyle: WidgetStatePropertyAll(
          const TextStyle(color: Colors.white),
        ),
        destinations: destinations,
      ),
    );
  }
}
