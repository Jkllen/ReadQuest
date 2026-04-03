import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_quest/screens/viewmodel/home_view_model.dart';
import 'package:read_quest/services/home_progress_service.dart';
import 'package:read_quest/styles/app_colors.dart';

class StartQuestCard extends StatelessWidget {
  final VoidCallback onOpenReadTab;

  const StartQuestCard({
    super.key,
    required this.onOpenReadTab,
  });

  @override
  Widget build(BuildContext context) {
    final homeProgressService = HomeProgressService();
    final homeViewModel = HomeViewModel(
      homeProgressService: homeProgressService,
    );

    if (homeProgressService.currentUserId == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: homeProgressService.progressStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              'Could not load quest progress.',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];
        final headlineText = homeViewModel.getHeadlineText(docs);
        final subtitleText = homeViewModel.getSubtitleText(docs);
        final buttonText = homeViewModel.getButtonText(docs);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withAlpha(64),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headlineText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'IBM Plex Sans',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitleText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'IBM Plex Sans',
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => homeViewModel.handleStartQuestTap(
                    context,
                    docs,
                    onOpenReadTab,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'IBM Plex Sans',
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
}