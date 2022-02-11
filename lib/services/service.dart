import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_practice/model/user.dart';

class DiaryService {
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> loginUser(String email, String password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUser(String name, BuildContext ctx, String uid) async {
    final user = MUser(
      name: name,
      avatarUrl: 'https://pisum.photos/200/300',
      profession: 'fucker',
      uid: uid,
    );
    userCollectionReference.add(user.toMap());
  }

  Future<void> update(
      MUser user, String name, String url, BuildContext ctx) async {
    final updateUser = MUser(name: name, avatarUrl: url, uid: user.uid);
    userCollectionReference.doc(user.id).update(updateUser.toMap());
  }
}
