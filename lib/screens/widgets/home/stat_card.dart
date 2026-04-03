import 'package:flutter/material.dart';
import 'package:read_quest/styles/card_styles.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color accentColor;
  final CrossAxisAlignment textAlign;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.accentColor,
    this.textAlign = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 118,
        padding: const EdgeInsets.all(20),
        decoration: CardStyles.borderCard(color: accentColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: textAlign,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
