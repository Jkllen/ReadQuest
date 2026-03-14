import 'package:flutter/material.dart';

class ReadHeader extends StatelessWidget {
  const ReadHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reading Quests',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Choose your adventure',
          style: TextStyle(
            color: Color(0xFF797979),
            fontSize: 14,
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}