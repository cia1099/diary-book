import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_practice/model/diary.dart';
import 'package:intl/intl.dart';
import 'package:web_practice/screens/main_page.dart';
import 'package:web_practice/util/utils.dart';
import 'package:web_practice/widgets/delete_entry_dialog.dart';
import 'package:web_practice/widgets/update_user_profile_dialog.dart';

import 'inner_list_card.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final bookCollectionReference =
        FirebaseFirestore.instance.collection('diaries');
    return StreamBuilder<QuerySnapshot>(
      stream: bookCollectionReference.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        final filterList = snapshot.data!.docs
            .map((doc) => Diary.fromDocument(doc))
            .where(
                (item) => item.userId == FirebaseAuth.instance.currentUser!.uid)
            .toList();
        return Column(
          children: [
            Expanded(
                child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView.builder(
                  itemCount: filterList.length,
                  itemBuilder: (ctx, i) {
                    final diary = filterList[i];
                    return Card(
                      elevation: 4,
                      child: InnerListCard(
                          selectedDate: this.selectedDate,
                          diary: diary,
                          bookCollectionReference: bookCollectionReference),
                    );
                  }),
            ))
          ],
        );
      },
    );
  }
}
