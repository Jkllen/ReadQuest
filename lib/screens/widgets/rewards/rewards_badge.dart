import 'package:flutter/material.dart';

class RewardsBadge extends StatelessWidget {
  const RewardsBadge({
    super.key,
    required this.context,
    required this.title,
    required this.color,
    required this.icon,
    required this.isLocked,
  });

  final BuildContext context;
  final String title;
  final Color color;
  final IconData icon;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    const double badgeSize = 88.0; 

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: badgeSize,
          height: badgeSize,
          decoration: BoxDecoration(
            color: isLocked ? const Color(0xFFF0F0F0) : color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white, width: 2), 
            boxShadow: [
              BoxShadow(
                color: isLocked ? Colors.grey.withValues(alpha: 0.1) : color.withValues(alpha: 0.4), 
                blurRadius: 10, 
                offset: const Offset(0, 0)
              )
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 36, color: isLocked ? Colors.grey.shade300 : Colors.white),
              if (isLocked)
                Icon(Icons.lock_outline, size: 24, color: Colors.grey.shade400),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: isLocked ? Colors.grey.shade400 : Colors.black87,
          ),
        ),
      ],
    );
  }
}
