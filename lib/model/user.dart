import 'package:cloud_firestore/cloud_firestore.dart';

class MUser {
  final String? id;
  final String? uid;
  final String? name;
  final String? profession;
  final String? avatarUrl;

  MUser({this.id, this.uid, this.name, this.profession, this.avatarUrl});

  factory MUser.fromDocument(QueryDocumentSnapshot data) {
    return MUser(
      id: data.id,
      uid: data.get('uid'),
      name: data.get('name'),
      profession: data.get('profession'),
      avatarUrl: data.get('avatar_url'),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'profession': profession,
      'avatar_url': avatarUrl,
    };
  }
}
