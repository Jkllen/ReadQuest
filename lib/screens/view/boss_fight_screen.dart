import 'package:flutter/material.dart';

class BossFightScreen extends StatelessWidget {
  const BossFightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Defining colors used in the design based on the magical palette
    const Color bgStartColor = Color(0xFF160A34); 
    const Color bgEndColor = Color(0xFF2A1054); 
    const Color cardColor = Color(0xFF1C1337); 
    const Color heroBlue = Color(0xFF4A67E2); 
    const Color bossMagenta = Color(0xFFD61868); 

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [bgStartColor, bgEndColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- HEADER TEXT ---
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
                      color: heroBlue,
                      label: 'HERO: YUAN',
                      progress: 1.0, 
                      isLeft: true,
                    ),
                    const SizedBox(width: 20),
                    _buildHealthBar(
                      icon: Icons.colorize, 
                      color: bossMagenta,
                      label: 'BOSS: SHADOW LEXICON',
                      progress: 0.3, 
                      isLeft: false,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // --- BOSS AVATAR WITH HP BADGE ---
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0F002A), 
                          border: Border.all(color: cardColor, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: bossMagenta.withValues(alpha: 0.1),
                              blurRadius: 40,
                              spreadRadius: 10,
                            )
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.visibility_outlined, 
                            size: 80,
                            color: bossMagenta.withValues(alpha: 0.6), 
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: bossMagenta,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: bossMagenta.withValues(alpha: 0.6),
                                blurRadius: 15,
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: const Text(
                            'HP\n50',
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
                const Spacer(),

                // --- INCOMING ATTACK CARD ---
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white12, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Header (Incoming Attack + Timer)
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
                          ), // <-- FIXED: Closing parentheses added here!
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.bolt, color: Colors.amber, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  '13s',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Question Text
                      const Text(
                        'What theme is strongly shown in the story?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Answer Options
                      _buildAnswerOption('Importance of fashion'),
                      const SizedBox(height: 12),
                      _buildAnswerOption('The danger of pride and desire for status'),
                      const SizedBox(height: 12),
                      _buildAnswerOption('The value of traveling'),
                      const SizedBox(height: 12),
                      _buildAnswerOption('The power of selective desire'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
            mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
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
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
              if (!isLeft) const SizedBox(width: 12),
              if (!isLeft) _buildIconContainer(icon, color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for the shield/sword icons
  Widget _buildIconContainer(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }

  // Helper method for the multiple choice buttons
  Widget _buildAnswerOption(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1C4F), 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}