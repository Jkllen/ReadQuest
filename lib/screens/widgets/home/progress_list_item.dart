import 'package:flutter/material.dart';
import 'package:read_quest/styles/card_styles.dart';


class ProgressListItem extends StatelessWidget {
  final String title;
  final String valueText;

  final Color pillBg;
  final Color valueColor;
  final double valueFontSize;

  const ProgressListItem({
    super.key,
    required this.title,
    required this.valueText,
    required this.pillBg,
    required this.valueColor,
    required this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 71,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: CardStyles.borderCard(),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4F4F4F),
              fontSize: 18,
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(10.5),
            ),
            child: Text(
              valueText,
              style: TextStyle(
                color: valueColor,
                fontSize: valueFontSize,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
