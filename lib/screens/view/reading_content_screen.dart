import 'package:flutter/material.dart';
import 'package:read_quest/screens/viewmodel/reading_content_view_model.dart';
import 'package:read_quest/styles/app_text_styles.dart';

class ReadingContentScreen extends StatefulWidget {
  final String readingId;
  final String title;
  final String author;
  final String summary;
  final String content;
  final int rewardXp;
  final double initialProgress;

  const ReadingContentScreen({
    super.key,
    required this.readingId,
    required this.title,
    required this.author,
    required this.summary,
    required this.content,
    required this.rewardXp,
    this.initialProgress = 0.0,
  });

  @override
  State<ReadingContentScreen> createState() => ReadingContentScreenState();
}

class ReadingContentScreenState extends State<ReadingContentScreen> {
  final ScrollController scrollController = ScrollController();
  final ReadingContentViewModel viewModel = ReadingContentViewModel();

  bool hasRestoredScroll = false;

  @override
  void initState() {
    super.initState();

    viewModel.initializeProgress(
      readingId: widget.readingId,
      title: widget.title,
      rewardXp: widget.rewardXp,
    );
    
    scrollController.addListener(handleScroll);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      restoreSavedScrollPosition();
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(handleScroll);
    scrollController.dispose();
    super.dispose();
  }

  void restoreSavedScrollPosition() {
    if(!mounted || hasRestoredScroll) return;

    if(!scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        restoreSavedScrollPosition();
      });
      return;
    }

    final maxScroll = scrollController.position.maxScrollExtent;
    final normalizedProgress = widget.initialProgress.clamp(0.0, 1.0);

    if(maxScroll <= 0 && normalizedProgress > 0) {
      Future.delayed(const Duration(microseconds: 100), () {
        restoreSavedScrollPosition();
      });
      return;
    }

    final targetOffset = (maxScroll * normalizedProgress).clamp(0.0, maxScroll);

    if (targetOffset > 0) {
      scrollController.jumpTo(targetOffset);
    }

    hasRestoredScroll = true;

  }

  void handleScroll() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    final currentScroll = scrollController.position.pixels.clamp(0.0, maxScroll,);
    final currentProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);

    viewModel.onScrollProgressChanged(
      readingId: widget.readingId,
      title: widget.title,
      rewardXp: widget.rewardXp,
      currentProgress: currentProgress,
    );
  }

  Future<void> handleTakeQuiz() async {
    await viewModel.completeReading(
      readingId: widget.readingId,
      title: widget.title,
      rewardXp: widget.rewardXp,
    );

    if (!mounted) return;

    debugPrint('Take quiz for: ${widget.readingId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 89,
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'READING QUEST',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.readingHeaderLabel,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.readingHeaderTitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: AppTextStyles.readingTitle),
                    const SizedBox(height: 6),
                    if (widget.author.isNotEmpty)
                      Text(
                        'by ${widget.author}',
                        style: AppTextStyles.readingAuthor,
                      ),
                    if (widget.summary.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 5,
                            height: 70,
                            decoration: BoxDecoration(
                              color: const Color(0xFF75BCFF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              widget.summary,
                              textAlign: TextAlign.justify,
                              style: AppTextStyles.readingSummary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      widget.content,
                      textAlign: TextAlign.justify,
                      style: AppTextStyles.readingBody,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: handleTakeQuiz,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF155DFC),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Take Quiz',
                          style: AppTextStyles.readingQuizButton,
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
