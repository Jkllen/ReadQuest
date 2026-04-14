import 'package:flutter/material.dart';
import 'package:read_quest/screens/view/home_tabs/read_tab.dart';
import 'package:read_quest/screens/view/home_tabs/rewards_tab.dart';
import 'package:read_quest/screens/view/home_tabs/dashboard_tab.dart';
import 'package:read_quest/screens/view/home_tabs/stats_tab.dart';
import 'package:read_quest/screens/widgets/home/app_nav_destination.dart';
import 'package:read_quest/styles/app_colors.dart';
import 'package:animate_gradient/animate_gradient.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  List<Widget> destinations = [
    const AppNavDestination(icon: Icons.dashboard, label: "Dashboard"),
    const AppNavDestination(icon: Icons.menu_book, label: "Read"),
    const AppNavDestination(icon: Icons.card_giftcard, label: "Rewards"),
    const AppNavDestination(icon: Icons.bar_chart, label: "Stats"),
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
      body: Stack(
        children: [
          AnimateGradient(
            primaryBegin: Alignment.topLeft,
            primaryEnd: Alignment.bottomLeft,
            secondaryBegin: Alignment.bottomLeft,
            secondaryEnd: Alignment.topRight,
            primaryColors: const [
              Color.fromARGB(255, 200, 112, 255),
              Color.fromARGB(255, 219, 169, 250),
              Colors.white,
            ],
            secondaryColors: const [
              Colors.white,
              Color.fromARGB(255, 170, 201, 255),
              Color.fromARGB(255, 108, 208, 255),
            ],
            duration: const Duration(seconds: 30),
          ),
          pages[currentIndex],
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        indicatorColor: const Color(0x33000000),
        backgroundColor: AppColors.navigationBar,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        labelTextStyle: WidgetStatePropertyAll(
          const TextStyle(color: Colors.white),
        ),
        destinations: destinations,
      ),
    );
  }
}
