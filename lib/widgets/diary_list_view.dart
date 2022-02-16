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
  const DiaryListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookCollectionReference =
        FirebaseFirestore.instance.collection('diaries');

    final listen = context.watch<GlobalVariable>();
    final isDescend = listen.isDescend;
    final selectedDate = listen.selectedTime;

    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Consumer<List<Diary>>(
              builder: (context, value, __) => FutureBuilder<List<Diary>>(
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
                                    diary: diary,
                                    bookCollectionReference:
                                        bookCollectionReference),
                              ),
                            );
                          })
                      : ListView.builder(
                          itemCount: 1,
                          itemBuilder: (_, i) {
                            return Card(
                              elevation: 4,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: MediaQuery.of(context).size.height *
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
              ),
            ),
          ),
        )
      ],
    );
  }
}
