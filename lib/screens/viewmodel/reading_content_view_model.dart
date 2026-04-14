import 'package:flutter/material.dart';
import 'package:read_quest/services/reading_progress_service.dart';
import 'package:read_quest/services/user_services.dart';

class ReadingContentViewModel {
  final ReadingProgressService readingProgressService;
  final UserService userService;

  double lastSavedProgress = 0.0;
  bool isSavingProgress = false;
  bool hasInitializedProgress = false;
  bool hasCompleted = false;

  ReadingContentViewModel({
    ReadingProgressService? readingProgressService,
    UserService? userService,
  }) : readingProgressService =
           readingProgressService ?? ReadingProgressService(),
       userService = userService ?? UserService();

  Future<void> initializeProgress({
    required String readingId,
    required String title,
    required int rewardXp,
  }) async {
    if (hasInitializedProgress) return;
    if (readingProgressService.currentUserId == null) return;

    hasInitializedProgress = true;

    try {
      final existingData = await readingProgressService.getProgress(readingId);

      final existingProgress = (existingData?['progress'] is num)
          ? (existingData!['progress'] as num).toDouble().clamp(0.0, 1.0)
          : 0.0;

      final existingCompleted = existingData?['isCompleted'] == true;

      lastSavedProgress = existingProgress;
      hasCompleted = existingCompleted;

      await readingProgressService.createOrInitializeProgress(
        readingId: readingId,
        title: title,
        rewardXp: rewardXp,
      );

      debugPrint('Initialized progress for $readingId: $lastSavedProgress');
    } catch (error) {
      debugPrint('initializeProgress error: $error');
    }
  }

  Future<void> onScrollProgressChanged({
    required String readingId,
    required String title,
    required int rewardXp,
    required double currentProgress,
  }) async {
    if (readingProgressService.currentUserId == null) return;
    if (isSavingProgress) return;

    final normalizedProgress = currentProgress.clamp(0.0, 1.0);

    debugPrint('Scroll progress: $normalizedProgress');

    if (hasCompleted && normalizedProgress < 1.0) {
      return;
    }

    if (normalizedProgress >= 0.98) {
      await completeReading(
        readingId: readingId,
        title: title,
        rewardXp: rewardXp,
      );
      return;
    }

    final difference = (normalizedProgress - lastSavedProgress).abs();

    if (difference < 0.05) {
      return;
    }

    isSavingProgress = true;

    try {
      await readingProgressService.saveProgress(
        readingId: readingId,
        title: title,
        progress: normalizedProgress,
        isCompleted: false,
        rewardXp: rewardXp,
      );

      lastSavedProgress = normalizedProgress;
      debugPrint('Saved progress for $readingId: $lastSavedProgress');
    } catch (error) {
      debugPrint('saveProgress error: $error');
    } finally {
      isSavingProgress = false;
    }
  }

  Future<void> completeReading({
    required String readingId,
    required String title,
    required int rewardXp,
  }) async {
    if (readingProgressService.currentUserId == null) return;
    if (isSavingProgress) return;
    if (hasCompleted) return;

    isSavingProgress = true;

    try {
      final startedAt =
          await readingProgressService.getStartedAt(readingId) ??
          DateTime.now();

      final completedAt = DateTime.now();

      await readingProgressService.saveProgress(
        readingId: readingId,
        title: title,
        progress: 1.0,
        isCompleted: true,
        rewardXp: rewardXp,
      );

      await userService.updateReadingStatsOnCompletion(
        readingId: readingId,
        startedAt: startedAt,
        completedAt: completedAt,
      );

      lastSavedProgress = 1.0;
      hasCompleted = true;
      debugPrint('Completed reading: $readingId');
    } catch (error) {
      debugPrint('completeReading error: $error');
    } finally {
      isSavingProgress = false;
    }
  }
}
