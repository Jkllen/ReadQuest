import 'package:flutter/material.dart';

class DailyChallengeCard extends StatelessWidget {
  final String title;
  final String reward;
  final String progress;
  final IconData icon;
  final Color iconColor;
  final bool isCompleted;
  final bool isClaimed;
  final VoidCallback? onClaim;

  const DailyChallengeCard({
    super.key,
    required this.title,
    required this.reward,
    required this.progress,
    required this.icon,
    required this.iconColor,
    required this.isCompleted,
    required this.isClaimed,
    this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final bool canClaim = isCompleted && !isClaimed;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reward,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF2078FC),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  progress,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A7A7A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: canClaim ? onClaim : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isClaimed
                  ? Colors.grey.shade400
                  : const Color(0xFF2078FC),
              disabledBackgroundColor: isClaimed
                  ? Colors.grey.shade400
                  : Colors.grey.shade300,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isClaimed
                  ? 'Claimed'
                  : (isCompleted ? 'Claim' : 'Locked'),
            ),
          ),
        ],
      ),
    );
  }
}