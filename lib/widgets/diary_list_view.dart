import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_practice/model/diary.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('diaries').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        final filterList = snapshot.data!.docs
            .map((doc) => Diary.fromDocument(doc))
            .where(
                (item) => item.userId == FirebaseAuth.instance.currentUser!.uid)
            .toList();
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: filterList.length,
                          itemBuilder: (ctx, i) {
                            final diary = filterList[i];
                            return SizedBox(
                              width: MediaQuery.of(ctx).size.width * 0.4,
                              child: Card(
                                elevation: 4,
                                child: ListTile(
                                  title: Text(diary.title),
                                ),
                              ),
                            );
                          }))
                ],
              )),
            ],
          ),
        );
      },
    );
  }
}
