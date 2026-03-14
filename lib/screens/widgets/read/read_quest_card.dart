import 'package:flutter/material.dart';

class ReadQuestCard extends StatelessWidget {
  final String title;
  final String author;
  final String type;
  final String difficulty;
  final String coverUrl;
  final int rewardXp;
  final double progress;
  final bool isLocked;
  final VoidCallback onTap;

  const ReadQuestCard({
    super.key,
    required this.title,
    required this.author,
    required this.type,
    required this.difficulty,
    required this.coverUrl,
    required this.rewardXp,
    required this.progress,
    required this.isLocked,
    required this.onTap,
  });

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF05DF72);
      case 'medium':
        return const Color(0xFFFDC700);
      case 'hard':
        return const Color(0xFFDF0505);
      default:
        return const Color(0xFF05DF72);
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    final difficultyColor = _difficultyColor(difficulty);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 337,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(37),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(37),
                    topRight: Radius.circular(37),
                  ),
                  child: SizedBox(
                    height: 185,
                    width: double.infinity,
                    child: coverUrl.isNotEmpty
                        ? Image.network(
                            coverUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: const Color(0xFFE5E7EB),
                                alignment: Alignment.center,
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          )
                        : Container(
                            color: const Color(0xFFE5E7EB),
                            alignment: Alignment.center,
                            child: const Icon(Icons.menu_book_rounded),
                          ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(31, 14, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (author.isNotEmpty)
                          Text(
                            'by $author',
                            style: const TextStyle(
                              color: Color(0xFF868686),
                              fontSize: 12,
                              fontFamily: 'IBM Plex Sans',
                            ),
                          ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: difficultyColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                difficulty.toUpperCase(),
                                style: TextStyle(
                                  color: difficultyColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'IBM Plex Sans',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              type.toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'IBM Plex Sans',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '+$rewardXp XP REWARD',
                          style: const TextStyle(
                            color: Color(0xFF155DFC),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'IBM Plex Sans',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'PROGRESS',
                              style: TextStyle(
                                color: Color(0xFFBCBCBC),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'IBM Plex Sans',
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '$percent%',
                              style: const TextStyle(
                                fontFamily: 'IBM Plex Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFD9D9D9),
                            color: const Color(0xFF155DFC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x93A6A6A6),
                  borderRadius: BorderRadius.circular(37),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'COMPLETE ONE DAILY CHALLENGE TO UNLOCK',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}