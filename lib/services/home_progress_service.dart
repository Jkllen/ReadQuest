import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeProgressService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  HomeProgressService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        auth = auth ?? FirebaseAuth.instance;

  String? get currentUserId => auth.currentUser?.uid;

  Stream<QuerySnapshot<Map<String, dynamic>>> progressStream() {
    final uid = currentUserId;
    if (uid == null) {
      throw Exception('User is not logged in.');
    }

    return firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getReadingById(
    String readingId,
  ) {
    return firestore.collection('readings').doc(readingId).get();
  }

  int readTimestampValue(dynamic value) {
    if (value is Timestamp) {
      return value.millisecondsSinceEpoch;
    }
    return 0;
  }

  QueryDocumentSnapshot<Map<String, dynamic>>? findContinueProgress(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final inProgressDocs = docs.where((doc) {
      final data = doc.data();
      final isCompleted = data['isCompleted'] == true;
      final progress = (data['progress'] as num?)?.toDouble() ?? 0.0;
      return !isCompleted && progress < 1.0;
    }).toList();

    inProgressDocs.sort((firstDoc, secondDoc) {
      final firstTime = readTimestampValue(firstDoc.data()['updatedAt']);
      final secondTime = readTimestampValue(secondDoc.data()['updatedAt']);
      return secondTime.compareTo(firstTime);
    });

    if (inProgressDocs.isEmpty) {
      return null;
    }

    return inProgressDocs.first;
  }
}