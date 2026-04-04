import 'package:flutter/material.dart';
import 'package:read_quest/styles/app_colors.dart';

class ReadQuestCard extends StatelessWidget {
  // Article Details
  final String title;
  final String author;
  final String type;
  final String coverUrl;

  // Quest Details
  final String difficulty;
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

  Color difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.difficulty.easy;
      case 'medium':
        return AppColors.difficulty.medium;
      case 'hard':
        return AppColors.difficulty.hard;
      default:
        return AppColors.difficulty.easy;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    final diffColor = difficultyColor(difficulty);

    final rounding = 36.0;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 420,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(rounding),
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(rounding),
                    topRight: Radius.circular(rounding),
                  ),
                  child: SizedBox(
                    height: 210,
                    width: double.infinity,
                    child: coverUrl.isNotEmpty
                        ? Image.network(
                            coverUrl.trim(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint(
                                'Cover URL Failed: ${coverUrl.trim()}',
                              );
                              debugPrint('Image load error: $error');
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
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Container(
                      color: Colors.amber.withAlpha(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              QuestInfo(
                                title: title,
                                author: author,
                                diffColor: diffColor,
                                difficulty: difficulty,
                                type: type,
                              ),
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '+$rewardXp XP REWARD',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'IBM Plex Sans',
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          ReadProgressBar(percent: percent, progress: progress),
                        ],
                      ),
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
                  color: Colors.grey.withAlpha(196),
                  borderRadius: BorderRadius.circular(rounding),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      Icon(Icons.lock_rounded, color: Colors.white, size: 96),
                      Text(
                        'COMPLETE ONE DAILY CHALLENGE TO UNLOCK',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ReadProgressBar extends StatelessWidget {
  const ReadProgressBar({
    super.key,
    required this.percent,
    required this.progress,
  });

  final int percent;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink.withAlpha(0),
      child: Column(
        children: [
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
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class QuestInfo extends StatelessWidget {
  const QuestInfo({
    super.key,
    required this.title,
    required this.author,
    required this.diffColor,
    required this.difficulty,
    required this.type,
  });

  final String title;
  final String author;
  final Color diffColor;
  final String difficulty;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.withAlpha(0),
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
            spacing: 8,
            children: [
              Text(
                type.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'IBM Plex Sans',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: diffColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      difficulty.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'IBM Plex Sans',
                      ),
                    ),
                    const SizedBox(width: 6),
                    DifficultyStars(difficulty: difficulty),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DifficultyStars extends StatelessWidget {
  const DifficultyStars({
    super.key,
    required this.difficulty,
  });

  final String difficulty;

  @override
  Widget build(BuildContext context) {
    int starCount;

    switch (difficulty.toLowerCase()) {
      case 'easy':
        starCount = 1;
        break;
      case 'medium':
        starCount = 2;
        break;
      case 'hard':
        starCount = 3;
        break;
      default:
        starCount = 0;
    }

    return Row(
      children: 
      List.generate(
        starCount,
        (index) => _StarIcon(Icons.star_rounded),
      ) + List.generate(
        3 - starCount,
        (index) => _StarIcon(Icons.star_border_rounded),
      ),
    );
  }

  Icon _StarIcon(IconData iconData) {
    return Icon(iconData, color: Colors.black, size: 14);
  }
}