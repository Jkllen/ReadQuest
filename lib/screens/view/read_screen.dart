import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_quest/screens/view/reading_content_screen.dart';
import 'package:read_quest/screens/widgets/menu_header.dart';
import 'package:read_quest/screens/widgets/read/read_category_chips.dart';
import 'package:read_quest/screens/widgets/read/read_quest_card.dart';
import 'package:read_quest/styles/app_spacings.dart';

enum ReadCategory {
  all,
  stories,
  articles,
  passages,
}

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  State<ReadScreen> createState() => ReadScreenState();
}

class ReadScreenState extends State<ReadScreen> {
  ReadCategory selectedCategory = ReadCategory.all;
  String searchQuery = "";

  String? typeFilter(ReadCategory category) {
    switch (category) {
      case ReadCategory.stories:
        return 'story';
      case ReadCategory.articles:
        return 'article';
      case ReadCategory.passages:
        return 'passage';
      case ReadCategory.all:
        return null;
    }
  }

  Query<Map<String, dynamic>> buildReadingsQuery() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('readings')
        .orderBy('order');

    final type = typeFilter(selectedCategory);
    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }

    return query;
  }

  bool matchesSearch(Map<String, dynamic> data) {
    if (searchQuery.trim().isEmpty) return true;

    final query = searchQuery.toLowerCase().trim();

    final title = (data['title'] ?? '').toString().toLowerCase();
    final author = (data['author'] ?? '').toString().toLowerCase();
    final type = (data['type'] ?? '').toString().toLowerCase();
    final difficulty = (data['difficulty'] ?? '').toString().toLowerCase();

    return title.contains(query) ||
        author.contains(query) ||
        type.contains(query) ||
        difficulty.contains(query);
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text('Not logged in.'),
          ),
        ),
      );
    }

    final query = buildReadingsQuery();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              MenuHeader(headerText: 'Reading Quests', subHeaderText: 'Choose your adventure...'),
              const SizedBox(height: 18),
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search quests...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFF5F7FB),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacings.section),

              ReadCategoryChips(
                value: selectedCategory,
                onChanged: (newCategory) {
                  setState(() => selectedCategory = newCategory);
                },
              ),
              const SizedBox(height: AppSpacings.section),

              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: query.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final docs = snapshot.data?.docs ?? [];
                    final filteredDocs = docs.where((doc) {
                      return matchesSearch(doc.data());
                    }).toList();

                    if (filteredDocs.isEmpty) {
                      return const Center(
                        child: Text('No matching quests found.'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 18),
                      itemCount: filteredDocs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacings.section),
                      itemBuilder: (context, index) {
                        final readingDoc = filteredDocs[index];
                        final data = readingDoc.data();

                        final title = (data['title'] ?? '').toString();
                        final author = (data['author'] ?? '').toString();
                        final type = (data['type'] ?? 'story').toString();
                        final difficulty =
                            (data['difficulty'] ?? 'easy').toString();
                        final coverUrl = (data['coverUrl'] ?? '').toString();
                        final rewardXp =
                            (data['rewardXp'] as num?)?.toInt() ?? 0;
                        final isLocked = (data['isLocked'] ?? false) as bool;

                        final progressDoc = FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('progress')
                            .doc(readingDoc.id);

                        return StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: progressDoc.snapshots(),
                          builder: (context, progressSnapshot) {
                            final progressData = progressSnapshot.data?.data();

                            final progress =
                                (progressData?['progress'] as num?)
                                        ?.toDouble() ??
                                    0.0;

                            return ReadQuestCard(
                              title: title,
                              author: author,
                              type: type,
                              difficulty: difficulty,
                              coverUrl: coverUrl,
                              rewardXp: rewardXp,
                              progress: progress.clamp(0.0, 1.0),
                              isLocked: isLocked,
                              onTap: () {
                                if (isLocked) return;

                                final summary =
                                    (data['summary'] ?? '').toString();
                                final content =
                                    (data['content'] ?? '').toString();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReadingContentScreen(
                                      readingId: readingDoc.id,
                                      title: title,
                                      author: author,
                                      summary: summary,
                                      content: content,
                                      rewardXp: rewardXp,
                                      initialProgress:
                                          progress.clamp(0.0, 1.0),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}