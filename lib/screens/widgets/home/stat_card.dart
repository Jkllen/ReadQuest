import 'package:flutter/material.dart';
import 'package:read_quest/styles/card_styles.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color accentColor;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.accentColor,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: accentColor,
                fontSize: 32,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: accentColor,
                fontSize: 13,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
