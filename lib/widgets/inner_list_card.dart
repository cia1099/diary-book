import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_practice/model/diary.dart';
import 'package:web_practice/util/utils.dart';
import 'package:web_practice/widgets/update_entry_dialog.dart';

import 'delete_entry_dialog.dart';

class InnerListCard extends StatelessWidget {
  const InnerListCard({
    Key? key,
    required this.diary,
    required this.bookCollectionReference,
  }) : super(key: key);

  final Diary diary;
  final CollectionReference<Map<String, dynamic>> bookCollectionReference;

  @override
  Widget build(BuildContext context) {
    final _titleTextController = TextEditingController(text: diary.title);
    final _descriptionTextController = TextEditingController(text: diary.entry);
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDateFromTimestamp(diary.entryTime),
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.grey,
                  ),
                  label: Text(''),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => DeleteEntryDialog(
                        bookCollectionReference: bookCollectionReference,
                        diary: diary),
                  ),
                ),
              ],
            ),
          ),
          subtitle: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '•' + fromDateFromTimestampHour(diary.entryTime),
                    style: TextStyle(color: Colors.green),
                  ),
                  TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.more_horiz, color: Colors.grey),
                      label: Text('')),
                ],
              ),
              Image.network(diary.photoUrls.isEmpty
                  ? 'https://picsum.photos/400/200'
                  : diary.photoUrls),
              Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            diary.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            diary.entry,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () => showDialog(
            context: context,
            builder: (context) => StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('diaries').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator.adaptive());
                }
                Diary? listenDiary;
                try {
                  listenDiary = snapshot.data!.docs
                      .map((doc) => Diary.fromDocument(doc))
                      .firstWhere((item) => item.id == diary.id);
                } on StateError catch (_) {
                  return AlertDialog(
                    content: const Text('There is not this date.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'))
                    ],
                  );
                }
                return AlertDialog(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Row(
                          children: [
                            Text(
                              formatDateFromTimestamp(listenDiary.entryTime),
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => UpdateEntryDialog(
                                    diary: listenDiary!,
                                    titleTextController: _titleTextController,
                                    descriptionTextController:
                                        _descriptionTextController,
                                    linkReference: bookCollectionReference,
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_forever_rounded),
                              onPressed: () async {
                                final isDeleted = await showDialog(
                                  context: context,
                                  builder: (context) => DeleteEntryDialog(
                                      bookCollectionReference:
                                          bookCollectionReference,
                                      diary: listenDiary!),
                                );
                                if (isDeleted) Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  content: ListTile(
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '•' +
                                  fromDateFromTimestampHour(
                                      listenDiary.entryTime),
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Image.network(listenDiary.photoUrls.isEmpty
                              ? 'https://picsum.photos/400/200'
                              : listenDiary.photoUrls),
                        ),
                        Row(
                          children: [
                            Flexible(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    listenDiary.title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    listenDiary.entry,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'))
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
