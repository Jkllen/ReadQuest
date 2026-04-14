import 'package:flutter/material.dart';
import 'package:read_quest/styles/app_colors.dart';
import 'package:read_quest/screens/viewmodel/boss_fight_view_model.dart';

class BossFightScreen extends StatelessWidget {
  final BossFightViewModel viewModel;

  const BossFightScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        // 1. LOADING STATE
        if (viewModel.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.boss.bgStartColor,
            body: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        // 2. MAIN BOSS UI
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.boss.bgStartColor, AppColors.boss.bgEndColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Boss Battle',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 20),

                          // --- HEALTH BARS ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildHealthBar(
                                icon: Icons.shield,
                                color: AppColors.boss.heroBlue,
                                label: 'HERO: YUAN',
                                progress: viewModel.playerHealthFactor,
                                isLeft: true,
                              ),
                              const SizedBox(width: 20),
                              _buildHealthBar(
                                icon: Icons.colorize,
                                color: AppColors.boss.bossMagenta,
                                label: 'BOSS: SHADOW LEXICON',
                                progress: viewModel.bossHealthFactor,
                                isLeft: false,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // --- BOSS AVATAR ---
                          Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.boss.cardColor,
                                    border: Border.all(color: AppColors.boss.cardColor, width: 4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.boss.bossMagenta.withValues(alpha: 0.1),
                                        blurRadius: 40,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.visibility_outlined,
                                      size: 80,
                                      color: AppColors.boss.bossMagenta.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.boss.bossMagenta,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      'HP\n${viewModel.bossHealth}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),

                          // --- ATTACK CARD ---
                          Container(
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: AppColors.boss.cardColor,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white12, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'INCOMING ATTACK!',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A2D3E),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: viewModel.remainingTime <= 5 ? Colors.redAccent : Colors.transparent,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.flash_on, 
                                            color: viewModel.remainingTime <= 5 ? Colors.redAccent : Colors.amberAccent, 
                                            size: 16
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${viewModel.remainingTime}s',
                                            style: TextStyle(
                                              color: viewModel.remainingTime <= 5 ? Colors.redAccent : Colors.amberAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  viewModel.questionText.isEmpty ? 'Loading...' : viewModel.questionText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // --- OPTIONS ---
                                ...viewModel.options.map((option) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: GestureDetector(
                                      onTap: () => viewModel.selectAnswer(option),
                                      child: _buildAnswerOption(option),
                                    ),
                                  );
                                }),

                                // --- PROGRESSION BUTTON ---
                                if (viewModel.answered && !viewModel.isTimeUp) ...[
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: viewModel.isVictory ? Colors.green : AppColors.boss.heroBlue,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                      onPressed: () async {
                                        // --- UPDATED: Using dynamic values ---
                                        final isDone = await viewModel.goNext(
                                          readingId: viewModel.currentReadingId, 
                                          difficulty: viewModel.currentDifficulty, 
                                        );
                                        
                                        if (isDone && context.mounted) {
                                          if (viewModel.isVictory) {
                                            _showVictoryDialog(context);
                                          } else if (viewModel.isGameOver) {
                                            _showDefeatDialog(context);
                                          } else {
                                            Navigator.pop(context); 
                                          }
                                        }
                                      },
                                      child: Text(
                                        viewModel.isVictory 
                                            ? 'CLAIM VICTORY' 
                                            : (viewModel.isGameOver ? 'CONTINUE' : 'NEXT STRIKE'),
                                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // --- "TIME'S UP" OVERLAY ---
              if (viewModel.isTimeUp)
                Container(
                  color: Colors.black.withValues(alpha: 0.85),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.boss.cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withValues(alpha: 0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer_off, color: Colors.redAccent, size: 64),
                          const SizedBox(height: 16),
                          const Text(
                            "TIME'S UP!",
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "You hesitated, and the Shadow Lexicon struck first.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                viewModel.retryQuestion(); 
                              },
                              child: const Text("TRY AGAIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
      },
    );
  }

  Widget _buildAnswerOption(String text) {
    final bool isSelected = viewModel.selectedAnswer == text;
    final bool isCorrect = text == viewModel.correctAnswer;
    
    Color backgroundColor = AppColors.boss.cardColor.withValues(alpha: 0.5);
    Color borderColor = Colors.white10;

    if (viewModel.answered) {
      if (isCorrect) {
        backgroundColor = Colors.green.withValues(alpha: 0.8);
        borderColor = Colors.greenAccent;
      } else if (isSelected && !isCorrect) {
        backgroundColor = Colors.red.withValues(alpha: 0.8);
        borderColor = Colors.redAccent;
      }
    } else if (isSelected) {
      backgroundColor = AppColors.boss.heroBlue.withValues(alpha: 0.8);
      borderColor = AppColors.boss.heroBlue;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isSelected || (viewModel.answered && isCorrect) ? 2 : 1),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildHealthBar({
    required IconData icon,
    required Color color,
    required String label,
    required double progress,
    required bool isLeft,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              if (isLeft) _buildIconContainer(icon, color),
              if (isLeft) const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: FractionallySizedBox(
                    alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ),
              ),
              if (!isLeft) const SizedBox(width: 12),
              if (!isLeft) _buildIconContainer(icon, color),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
      child: Icon(icon, size: 16, color: color),
    );
  }

  // --- NEW DIALOG METHODS ---

  void _showVictoryDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.boss.bgStartColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'VICTORY!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white, 
              fontSize: 32, 
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Shadow Lexicon Defeated',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.stars_rounded, color: Colors.amber, size: 48),
                  SizedBox(width: 12),
                  Text(
                    '+ 65 EXP',
                    style: TextStyle(
                      color: Colors.amber, 
                      fontSize: 36, 
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.boss.heroBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
                Navigator.of(context).pop(); 
              },
              child: const Text(
                'CLAIM REWARD', 
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDefeatDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.boss.bgStartColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'DEFEAT',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.boss.bossMagenta, 
              fontSize: 32, 
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          content: const Text(
            'Your health was depleted. The Shadow Lexicon stands victorious... for now.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.boss.bossMagenta,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    // --- UPDATED: Using dynamic values ---
                    viewModel.loadBossFight(
                      readingId: viewModel.currentReadingId, 
                      difficulty: viewModel.currentDifficulty,
                    );
                  },
                  child: const Text(
                    'TRY AGAIN', 
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); 
                    Navigator.of(context).pop(); 
                  },
                  child: const Text(
                    'Retreat to Menu', 
                    style: TextStyle(color: Colors.white54, fontSize: 14)
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}