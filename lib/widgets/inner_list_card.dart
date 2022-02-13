import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_practice/model/diary.dart';
import 'package:web_practice/util/utils.dart';

import 'delete_entry_dialog.dart';

class InnerListCard extends StatelessWidget {
  const InnerListCard({
    Key? key,
    required this.diary,
    required this.bookCollectionReference,
    required this.selectedDate,
  }) : super(key: key);

  final Diary diary;
  final DateTime selectedDate;
  final CollectionReference<Map<String, dynamic>> bookCollectionReference;

  @override
  Widget build(BuildContext context) {
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
            builder: (context) => AlertDialog(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Row(
                      children: [
                        Text(
                          formatDateFromTimestamp(diary.entryTime),
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // showDialog(context: context, builder: (context) => UpdateUserProfileDialog(currentUser: currentUser, avatarUrlTextController: avatarUrlTextController, nameTextController: nameTextController),)
                            Navigator.of(context).pop();
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
                                  diary: diary),
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
                          '•' + fromDateFromTimestampHour(diary.entryTime),
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Image.network(diary.photoUrls.isEmpty
                          ? 'https://picsum.photos/400/200'
                          : diary.photoUrls),
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
                        ))
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
