import 'package:flutter/material.dart';
import 'package:read_quest/styles/card_styles.dart';

class ProgressListItem extends StatelessWidget {
  final String title;
  final String valueText;

  final Color valueColor;

  const ProgressListItem({
    super.key,
    required this.title,
    required this.valueText,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(18),
        decoration: CardStyles.borderCard(color: valueColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              valueText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: valueColor,
                fontSize: 28,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: valueColor,
                fontSize: 14,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
