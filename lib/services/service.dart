import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_practice/model/diary.dart';
import 'package:web_practice/model/user.dart';

class DiaryService {
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('diaries');

  Future<void> loginUser(String email, String password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUser(String name, BuildContext ctx, String uid) async {
    final user = MUser(
      name: name,
      avatarUrl: 'https://i.pravatar.cc/100',
      profession: 'not thing',
      uid: uid,
    );
    userCollectionReference.add(user.toMap());
  }

  Future<void> update(
      MUser user, String name, String url, BuildContext ctx) async {
    final updateUser = MUser(
        name: name, avatarUrl: url, uid: user.uid, profession: user.profession);
    userCollectionReference.doc(user.id).update(updateUser.toMap());
  }

  Future<List<Diary>> getSameDateDiary(DateTime? first, String userId,
      [bool isDescend = true]) async {
    var query = first != null
        ? diaryCollectionReference
            .where('entry_time',
                isGreaterThanOrEqualTo: Timestamp.fromDate(first).toDate())
            .where('entry_time',
                isLessThan:
                    Timestamp.fromDate(first.add(const Duration(days: 1)))
                        .toDate())
        : diaryCollectionReference.where('entry_time',
            isLessThan: DateTime.now());

    return query
        .where('user_id', isEqualTo: userId)
        .orderBy('entry_time', descending: isDescend)
        .get()
        .then((value) =>
            value.docs.map((diary) => Diary.fromDocument(diary)).toList());
  }

  Future<List<Diary>> getLatestDiaries(String uid) async {
    return diaryCollectionReference
        .where('user_id', isEqualTo: uid)
        .orderBy('entry_time', descending: true)
        .get()
        .then((value) =>
            value.docs.map((doc) => Diary.fromDocument(doc)).toList());
  }

  Future<List<Diary>> getEarliestDiaries(String uid) async {
    return diaryCollectionReference
        .where('user_id', isEqualTo: uid)
        .orderBy('entry_time', descending: false)
        .get()
        .then((value) =>
            value.docs.map((doc) => Diary.fromDocument(doc)).toList());
  }
}
