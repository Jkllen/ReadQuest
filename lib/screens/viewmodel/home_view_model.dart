import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:read_quest/screens/view/read_screen.dart';
import 'package:read_quest/screens/view/reading_content_screen.dart';
import 'package:read_quest/services/home_progress_service.dart';

class HomeViewModel {
  final HomeProgressService homeProgressService;

  HomeViewModel({
    HomeProgressService? homeProgressService,
  }) : homeProgressService = homeProgressService ?? HomeProgressService();

  String getHeadlineText(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return docs.isEmpty ? 'Start Your First Quest' : 'Continue Reading';
  }

  String getButtonText(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return docs.isEmpty ? 'Start Quest' : 'Continue';
  }

  String getSubtitleText(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    if (docs.isEmpty) {
      return 'Begin your first reading adventure.';
    }

    final continueDoc = homeProgressService.findContinueProgress(docs);

    if (continueDoc == null) {
      return 'Choose your next reading quest';
    }

    return (continueDoc.data()['title'] ?? 'Continue your quest').toString();
  }

  Future<void> openReadScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReadScreen(),
      ),
    );
  }

  Future<void> openContinueReading(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>> progressDoc,
  ) async {
    final progressData = progressDoc.data();
    final readingId = (progressData['readingId'] ?? progressDoc.id).toString();
    final savedProgress =
        ((progressData['progress'] as num?)?.toDouble() ?? 0.0).clamp(0.0, 1.0);

    final readingSnapshot = await homeProgressService.getReadingById(readingId);

    if (!readingSnapshot.exists) {
      if (!context.mounted) return;
      await openReadScreen(context);
      return;
    }

    final readingData = readingSnapshot.data() ?? {};
    final title = (readingData['title'] ?? '').toString();
    final author = (readingData['author'] ?? '').toString();
    final summary = (readingData['summary'] ?? '').toString();
    final content = (readingData['content'] ?? '').toString();
    final rewardXp = (readingData['rewardXp'] as num?)?.toInt() ?? 0;

    if (!context.mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReadingContentScreen(
          readingId: readingId,
          title: title,
          author: author,
          summary: summary,
          content: content,
          rewardXp: rewardXp,
          initialProgress: savedProgress,
        ),
      ),
    );
  }

  Future<void> handleStartQuestTap(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) async {
    if (docs.isEmpty) {
      await openReadScreen(context);
      return;
    }

    final continueDoc = homeProgressService.findContinueProgress(docs);

    if (continueDoc == null) {
      await openReadScreen(context);
      return;
    }

    await openContinueReading(context, continueDoc);
  }
}