import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  final String? id;
  final String userId;
  final String title;
  final String author;
  final Timestamp entryTime;
  final String photoUrls;
  final String entry;

  Diary(
      {this.id,
      required this.userId,
      required this.title,
      required this.author,
      required this.entryTime,
      required this.photoUrls,
      required this.entry});

  factory Diary.fromDocument(QueryDocumentSnapshot data) {
    return Diary(
        id: data.id,
        userId: data.get('user_id'),
        author: data.get('author'),
        entryTime: data.get('entry_time'),
        photoUrls: data.get('photo_lists'),
        title: data.get('title'),
        entry: data.get('entry'));
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'author': author,
      'entry': entry,
      'photo_lists': photoUrls,
      'entry_time': entryTime,
    };
  }
}
