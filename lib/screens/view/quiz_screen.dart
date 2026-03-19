import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  final String title;

  const QuizScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 89,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),

                  // Divider / Progress line (center)
                  Expanded(
                    child: Container(
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(21),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 0, // <-- later dynamic progress
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4378FF),
                            borderRadius: BorderRadius.circular(21),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    '0/0', // placeholder
                    style: TextStyle(
                      color: Color(0xFFA9A9A9),
                      fontSize: 15,
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(33, 32, 33, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Container (EMPTY FOR NOW)
                    Container(
                      width: double.infinity,
                      child: const Text(
                        '', // <-- will come from Firestore
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Progress Bar
                    Container(
                      width: double.infinity,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF50D8FD),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),

                    const SizedBox(height: 42),

                    // Choices (Placeholders)
                    const _QuizOption(),
                    const SizedBox(height: 27),
                    const _QuizOption(),
                    const SizedBox(height: 27),
                    const _QuizOption(),
                    const SizedBox(height: 27),
                    const _QuizOption(),

                    const SizedBox(height: 27),

                    // Feedback Container (Placeholder)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 1.48,
                          color: const Color(0xFFDCFCE7),
                        ),
                      ),
                      child: const Text(
                        '', // <-- explanation from DB later
                        style: TextStyle(
                          color: Color(0xFF016630),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.43,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Boss battle placeholder'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF155DFC),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: const Color(0xFFDBEAFE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Face the Boss!',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizOption extends StatelessWidget {
  const _QuizOption();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 78,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '', // <-- option text from DB later
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF6F6F6F),
            fontSize: 16,
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
