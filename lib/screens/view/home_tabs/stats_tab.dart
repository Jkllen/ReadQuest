import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:read_quest/screens/widgets/menu_header.dart';
import 'package:read_quest/screens/widgets/stats/skill_card.dart';
import 'package:read_quest/styles/app_colors.dart';
import 'package:read_quest/styles/app_spacings.dart';
import 'package:read_quest/styles/card_styles.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  // Helper method to format DateTime to "YYYY-MM-DD"
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  double getWeeklyTotal(Map<String, dynamic> dailyStats, DateTime startOfWeek) {
    double total = 0.0;
    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      String dateKey = _formatDate(day);
      total += (dailyStats[dateKey] ?? 0.0).toDouble();
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const SafeArea(child: Center(child: Text("Not logged in.")));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SafeArea(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SafeArea(
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};

        // --- DYNAMIC DATA EXTRACTION ---

        // 1. Skill Mastery
        final int vocabulary = (data['vocabulary'] ?? 0).toInt();
        final int wordsLearned = (data['wordsLearned'] ?? 0).toInt();

        // Defaulting these to 0 since they aren't in this specific DB snapshot
        final int comprehension = (data['comprehension'] ?? 0).toInt();
        final int readingSpeed = (data['readingSpeed'] ?? 0).toInt();

        // --- 2. WEEKLY GROWTH ---
        // Reading the static value directly from your Firestore document
        final int weeklyGrowth = (data['weeklyGrowth'] ?? 0).toInt();

        final bool isPositiveGrowth = weeklyGrowth >= 0;
        final String growthText = isPositiveGrowth
            ? "+$weeklyGrowth% from yesterday"
            : "$weeklyGrowth% from yesterday";

        final Color growthColor = isPositiveGrowth
            ? const Color.fromARGB(211, 120, 230, 123)
            : const Color.fromARGB(192, 214, 97, 89);

        final IconData growthIcon = isPositiveGrowth
            ? Icons.trending_up
            : Icons.trending_down;

        // --- 3. WEEKLY PROGRESS CHART DATA ---
        // Changed to 'weeklyProgress' to match your database field!
        final List<dynamic> rawWeeklyData =
            data['weeklyProgress'] ?? [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

        List<FlSpot> chartSpots = [];
        double maxY = 5.0; // Base max Y

        for (int i = 0; i < rawWeeklyData.length; i++) {
          final double val = (rawWeeklyData[i] is num)
              ? (rawWeeklyData[i] as num).toDouble()
              : 0.0;

          // Dynamically adjust the chart's height based on your data (e.g., if you have 100)
          if (val > maxY) maxY = val + 10.0;

          chartSpots.add(FlSpot(i.toDouble(), val));
        }

        if (chartSpots.isEmpty) {
          chartSpots = List.generate(7, (index) => FlSpot(index.toDouble(), 0));
        }
        return Scaffold(
          backgroundColor: AppColors.homeBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacings.homeTabPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MenuHeader(
                    headerText: 'Reading Statistics',
                    subHeaderText: 'View your progress',
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: CardStyles.borderCard(color: growthColor),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                growthIcon,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Daily Progression",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  growthText,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Wavy Line Chart
                        SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 22,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      // 1. Generate the last 7 days dynamically
                                      DateTime now = DateTime.now();
                                      List<String> dynamicDays = [];
                                      const weekDays = [
                                        'Mon',
                                        'Tue',
                                        'Wed',
                                        'Thu',
                                        'Fri',
                                        'Sat',
                                        'Sun',
                                      ];
                                      for (int i = 0; i < 7; i++) {
                                        DateTime historicalDay = now.subtract(
                                          Duration(days: 6 - i),
                                        );

                                        dynamicDays.add(
                                          weekDays[historicalDay.weekday - 1],
                                        );
                                      }

                                      if (value.toInt() >= 0 &&
                                          value.toInt() < dynamicDays.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Text(
                                            // If today is index 6, you might want to label it 'Today' instead of the day name!
                                            // value.toInt() == 6 ? 'Today' : dynamicDays[value.toInt()],
                                            dynamicDays[value.toInt()],
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: chartSpots,
                                  isCurved: true,
                                  color: Colors.black87,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black12,
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                              minY: 0,
                              maxY: maxY,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Skills Mastery",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SkillCard(
                    title: "Comprehension",
                    percentage: comprehension,
                    accentColor: AppColors.stats.comprehensionCard,
                    iconData: Icons.menu_book_rounded,
                  ),
                  const SizedBox(height: 14),
                  SkillCard(
                    title: "Vocabulary",
                    percentage: vocabulary,
                    accentColor: AppColors.stats.vocabularyCard,
                    iconData: Icons.psychology_rounded,
                  ),
                  const SizedBox(height: 14),
                  SkillCard(
                    title: "Reading Speed",
                    percentage: readingSpeed,
                    accentColor: AppColors.stats.speedCard,
                    iconData: Icons.wifi_tethering_rounded,
                  ),
                  const SizedBox(height: 14),
                  SkillCard(
                    title: "Words Learned",
                    percentage: wordsLearned, // Currently 6
                    accentColor: Colors.blueAccent,
                    iconData: Icons.translate_rounded,
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
