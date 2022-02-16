import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_practice/model/diary.dart';
import 'package:intl/intl.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:web_practice/model/global.dart';

import 'package:web_practice/model/user.dart';
import 'package:web_practice/screens/main_page.dart';
import 'package:web_practice/services/service.dart';
import 'package:web_practice/util/utils.dart';
import 'package:web_practice/widgets/delete_entry_dialog.dart';
import 'package:web_practice/widgets/update_user_profile_dialog.dart';
import 'package:web_practice/widgets/write_diary_dialog.dart';

import 'inner_list_card.dart';

class DiaryListView extends StatelessWidget {
  DiaryListView({
    Key? key,
    // required this.listOfDiaries,
    this.selectedDate,
  }) : super(key: key);
  DateTime? selectedDate;
  // final List<Diary> listOfDiaries;

  @override
  Widget build(BuildContext context) {
    final bookCollectionReference =
        FirebaseFirestore.instance.collection('diaries');

    // final user = Provider.of<User?>(context);
    // final user = context.read<User?>(); //listenning will cause bug when logout
    final isDescend = context.read<GlobalVariable>().isDescend;
    // final filteredDiaryList =
    //     // listOfDiaries.where((item) => item.userId == user!.uid).toList();
    //     DiaryService().getSameDateDiary(selectedDate, user!.uid);
    return Column(
      children: [
        Expanded(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: FutureBuilder<List<Diary>>(
                  future: DiaryService().getSameDateDiary(selectedDate,
                      FirebaseAuth.instance.currentUser!.uid, isDescend),
                  initialData: [],
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );

                    final filteredDiaryList = snapshot.data!;
                    return filteredDiaryList.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredDiaryList.length,
                            itemBuilder: (_, i) {
                              final diary = filteredDiaryList[i];
                              return DelayedDisplay(
                                delay: const Duration(milliseconds: 2),
                                fadeIn: true,
                                child: Card(
                                  elevation: 4,
                                  child: InnerListCard(
                                      // selectedDate: this.selectedDate,
                                      diary: diary,
                                      bookCollectionReference:
                                          bookCollectionReference),
                                ),
                              );
                            })
                        : ListView.builder(
                            itemCount: 1,
                            itemBuilder: (_, i) {
                              // final diary = listOfDiaries[i];
                              return Card(
                                elevation: 4,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Safeguard your memory on ${formatDate(selectedDate ?? DateTime.now())}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                            TextButton.icon(
                                                onPressed: () => showDialog(
                                                      context: context,
                                                      builder: (context) => WriteDiaryDialog(
                                                          selectedDate:
                                                              selectedDate ??
                                                                  DateTime
                                                                      .now(),
                                                          titleTextController:
                                                              TextEditingController(),
                                                          descriptionTextController:
                                                              TextEditingController()),
                                                    ),
                                                icon: Icon(
                                                    Icons.lock_outline_sharp),
                                                label: Text(
                                                    'Click to Add an Entry')),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                  },
                )))
      ],
    );
  }
}

/*
StreamBuilder<QuerySnapshot>(
            stream: bookCollectionReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator.adaptive());
              }
              final filterList = snapshot.data!.docs
                  .map((doc) => Diary.fromDocument(doc))
                  .where((item) =>
                      item.userId == FirebaseAuth.instance.currentUser!.uid)
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
                                bookCollectionReference:
                                    bookCollectionReference),
                          );
                        }),
                  ))
                ],
              );
            },
          )
*/ 