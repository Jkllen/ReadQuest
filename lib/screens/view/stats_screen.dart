import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:read_quest/screens/view/home_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _currentIndex = 3;

  final List<Widget> pages = const [
    Center(child: Text("Home Page Placeholder")),
    Center(child: Text("Read Page")),
    Center(child: Text("Rewards Page")),
    StatsTab(),
  ];

  void _onTap(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: const Color(0xFF2078FC),
        unselectedItemColor: const Color(0xFF999BA0),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Read"),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Rewards",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
        ],
      ),
    );
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
          return const Center(child: CircularProgressIndicator());
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
          double val = (rawWeeklyData[i] is num)
              ? (rawWeeklyData[i] as num).toDouble()
              : 0.0;
          if (val > maxY)
            maxY = val + 1.0; // Auto-scale chart height if data is high
          chartSpots.add(FlSpot(i.toDouble(), val));
        }

        // Fallback to a flat line if data is missing or empty
        if (chartSpots.isEmpty) {
          chartSpots = List.generate(6, (index) => FlSpot(index.toDouble(), 0));
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/read_quest_logo_splash.png",
                      height: 55,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, size: 55, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Reading Quests",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Mission Statistics",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Card Header
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
                                      const Color(0xFF3B82F6).withOpacity(0.2),
                                      const Color(0xFF3B82F6).withOpacity(0.0),
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

                // Skill Cards
                SkillCard(
                  title: "Comprehension",
                  percentage: comprehension,
                  progressColor: const Color(0xFF3B82F6),
                  iconData: Icons.menu_book_rounded,
                  iconBgColor: const Color(0xFFEFF6FF),
                ),
                const SizedBox(height: 14),
                SkillCard(
                  title: "Vocabulary",
                  percentage: vocabulary,
                  progressColor: const Color(0xFFA855F7),
                  iconData: Icons.psychology_rounded,
                  iconBgColor: const Color(0xFFFAF5FF),
                ),
                const SizedBox(height: 14),
                SkillCard(
                  title: "Reading Speed",
                  percentage: readingSpeed,
                  progressColor: const Color(0xFF10B981),
                  iconData: Icons.wifi_tethering_rounded,
                  iconBgColor: const Color(0xFFECFDF5),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SkillCard extends StatelessWidget {
  final String title;
  final int percentage;
  final Color progressColor;
  final IconData iconData;
  final Color iconBgColor;

  const SkillCard({
    super.key,
    required this.title,
    required this.percentage,
    required this.progressColor,
    required this.iconData,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final double safePercentage = (percentage.clamp(0, 100)) / 100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(iconData, color: progressColor, size: 26),
          ),
          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                    Text(
                      "$percentage%",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: progressColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: safePercentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: progressColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
