import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:read_quest/screens/widgets/read/read_category_chips.dart';
import 'package:read_quest/screens/widgets/read/read_header.dart';
import 'package:read_quest/screens/widgets/read/read_logo_menu.dart';
import 'package:read_quest/screens/widgets/read/read_quest_card.dart';

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
  ReadCategory category = ReadCategory.all;

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

    final type = typeFilter(category);
    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }

    return query;
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const SafeArea(
        child: Center(
          child: Text('Not logged in.'),
        ),
      );
    }

    final query = buildReadingsQuery();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            const Row(
              children: [
                ReadQuestLogoMenu(),
                SizedBox(width: 12),
                Expanded(child: ReadHeader()),
              ],
            ),
            const SizedBox(height: 18),
            ReadCategoryChips(
              value: category,
              onChanged: (category) {
                setState(() => category = category);
              },
            ),
            const SizedBox(height: 18),
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

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text('No quests yet.'),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 18),
                    itemCount: docs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final readingDoc = docs[index];
                      final data = readingDoc.data();

                      final title = (data['title'] ?? '').toString();
                      final author = (data['author'] ?? '').toString();
                      final type = (data['type'] ?? 'story').toString();
                      final difficulty =
                          (data['difficulty'] ?? 'easy').toString();
                      final coverUrl = (data['coverUrl'] ?? '').toString();
                      final rewardXp = (data['rewardXp'] ?? 0) as int;
                      final isLocked = (data['isLocked'] ?? false) as bool;

                      final progressDoc = FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('progress')
                          .doc(readingDoc.id);

                      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: progressDoc.snapshots(),
                        builder: (context, progressSnapshot) {
                          final progressData = progressSnapshot.data?.data();

                          final progress = (progressData?['progress'] is num)
                              ? (progressData!['progress'] as num).toDouble()
                              : 0.0;

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

                              debugPrint('Open reading: ${readingDoc.id}');
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
    );
  }
}