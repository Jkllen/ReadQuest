import 'package:flutter/material.dart';


class XpProgressBar extends StatelessWidget {
  final int currentXp;
  final int targetXp;

  const XpProgressBar({
    super.key,
    required this.currentXp,
    required this.targetXp,
  });

  String _formatNumber(int n) {
    final s = n.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final reverseIndex = s.length - i;
      buffer.write(s[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = targetXp == 0
        ? 0
        : (currentXp / targetXp).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          children: [
            const Text(
              'XP Progress',
              style: TextStyle(
                color: Color(0xFF8B8B8B),
                fontSize: 14,
                fontFamily: 'Maname',
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Text(
              '${_formatNumber(currentXp)}/${_formatNumber(targetXp)} XP',
              style: const TextStyle(
                color: Color(0xFF8B8B8B),
                fontSize: 14,
                fontFamily: 'Maname',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(18.5),
          child: Container(
            height: 13,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              borderRadius: BorderRadius.circular(18.5),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B7FFF),
                      borderRadius: BorderRadius.circular(18.5),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
