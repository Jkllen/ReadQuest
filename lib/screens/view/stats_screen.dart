import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:read_quest/screens/widgets/menu_header.dart';
import 'package:read_quest/screens/widgets/stats/skill_card.dart';
import 'package:read_quest/styles/app_colors.dart';
import 'package:read_quest/styles/card_styles.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatsTab();
  }
}

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

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
        final int comprehension = (data['comprehension'] ?? 0).toInt();
        final int vocabulary = (data['vocabulary'] ?? 0).toInt();
        final int readingSpeed = (data['readingSpeed'] ?? 0).toInt();

        // 2. Weekly Growth Percentage
        final int weeklyGrowth = (data['weeklyGrowth'] ?? 0).toInt();
        final bool isPositiveGrowth = weeklyGrowth >= 0;
        final String growthText = isPositiveGrowth
            ? "+$weeklyGrowth% from last week"
            : "$weeklyGrowth% from last week";
        final Color growthColor = isPositiveGrowth
            ? const Color(0xFF22C55E)
            : const Color(0xFFEF4444);
        final IconData growthIcon = isPositiveGrowth
            ? Icons.trending_up
            : Icons.trending_down;
        final Color growthBgColor = isPositiveGrowth
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFEE2E2);

        // 3. Weekly Progress Chart Data
        final List<dynamic> rawWeeklyData =
            data['weeklyProgress'] ?? [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

        List<FlSpot> chartSpots = [];
        double maxY = 5.0;

        for (int i = 0; i < rawWeeklyData.length; i++) {
          final double val = (rawWeeklyData[i] is num)
              ? (rawWeeklyData[i] as num).toDouble()
              : 0.0;

          if (val > maxY) {
            maxY = val + 1.0;
          }

          chartSpots.add(FlSpot(i.toDouble(), val));
        }
        // Fallback to a flat line if data is missing or empty
        if (chartSpots.isEmpty) {
          chartSpots = List.generate(6, (index) => FlSpot(index.toDouble(), 0));
        }

        return Scaffold(
          backgroundColor: AppColors.homeBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
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
                    decoration: CardStyles.borderCard(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: growthBgColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                growthIcon,
                                color: growthColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "WEEKLY GROWTH",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                Text(
                                  growthText,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: growthColor,
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
                                      const days = [
                                        'Tue',
                                        'Wed',
                                        'Thu',
                                        'Fri',
                                        'Sat',
                                        'Sun',
                                      ];

                                      if (value.toInt() >= 0 &&
                                          value.toInt() < days.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Text(
                                            days[value.toInt()],
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
                                  color: const Color(0xFF3B82F6),
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(
                                          0xFF3B82F6,
                                        ).withValues(alpha: 0.2),
                                        const Color(
                                          0xFF3B82F6,
                                        ).withValues(alpha: 0.0),
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
                    accentColor: const Color(0xFF3B82F6),
                    iconData: Icons.menu_book_rounded,
                  ),
                  const SizedBox(height: 14),
                  SkillCard(
                    title: "Vocabulary",
                    percentage: vocabulary,
                    accentColor: const Color(0xFFA855F7),
                    iconData: Icons.psychology_rounded,
                  ),
                  const SizedBox(height: 14),
                  SkillCard(
                    title: "Reading Speed",
                    percentage: readingSpeed,
                    accentColor: const Color(0xFF10B981),
                    iconData: Icons.wifi_tethering_rounded,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
