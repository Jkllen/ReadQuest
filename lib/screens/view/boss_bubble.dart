import 'package:flutter/material.dart';
import 'boss_fight_screen.dart'; // Make sure this matches your file name!

class BossBubble extends StatelessWidget {
  const BossBubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100, // Adjust this to move it higher or lower
      right: 16, // Keeps it on the right side
      child: Material(
        elevation: 8,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            // Navigates to the Boss Fight tab!
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BossFightScreen()),
            );
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE11D48), Colors.deepOrange],
              ),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: const Icon(
              Icons.colorize, // Sword placeholder
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}