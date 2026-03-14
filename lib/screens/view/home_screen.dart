import 'package:flutter/material.dart';
import 'package:read_quest/screens/view/read_screen.dart';
import 'package:read_quest/screens/widgets/home/home_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeTab(),
    ReadScreen(),
    Center(child: Text("Rewards Page")),
    Center(child: Text("Stats Page")),
  ];

  void onTap(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
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