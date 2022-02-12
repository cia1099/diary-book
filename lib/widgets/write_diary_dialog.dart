import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_practice/model/diary.dart';

class WriteDiaryDialog extends StatefulWidget {
  const WriteDiaryDialog({
    Key? key,
    required this.selectedDate,
    required TextEditingController titleTextController,
    required TextEditingController descriptionTextController,
  })  : _titleTextController = titleTextController,
        _descriptionTextController = descriptionTextController,
        super(key: key);

  final TextEditingController _titleTextController;
  final TextEditingController _descriptionTextController;
  final DateTime selectedDate;

  @override
  State<WriteDiaryDialog> createState() => _WriteDiaryDialogState();
}

class _WriteDiaryDialogState extends State<WriteDiaryDialog> {
  var _buttonText = 'Done';
  CollectionReference diaryCollectionReference =
      FirebaseFirestore.instance.collection('diaries');
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Discard'),
                    style: TextButton.styleFrom(primary: Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text(_buttonText),
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.green,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            side: BorderSide(color: Colors.green, width: 1))),
                    onPressed: () {
                      final _fieldsNotEmpty =
                          widget._titleTextController.text.isNotEmpty &&
                              widget._descriptionTextController.text.isNotEmpty;
                      if (_fieldsNotEmpty) {
                        diaryCollectionReference.add(Diary(
                                title: widget._titleTextController.text,
                                entry: widget._descriptionTextController.text,
                                author: FirebaseAuth
                                    .instance.currentUser!.email!
                                    .split('@')[0],
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                photoUrls: '',
                                entryTime:
                                    Timestamp.fromDate(widget.selectedDate))
                            .toMap());
                      }
                      setState(() {
                        _buttonText = 'Saving...';
                      });
                      Future.delayed(Duration(milliseconds: 2500))
                          .then((value) => Navigator.of(context).pop());
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white12,
                      child: Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.image_rounded),
                            splashRadius: 26,
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat.yMMMd().format(widget.selectedDate)),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Form(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.8 /
                                      2,
                                  child: Container(
                                    color: Colors.green,
                                    width: 700,
                                    child: Text('image here'),
                                  ),
                                ),
                                TextFormField(
                                  controller: widget._titleTextController,
                                  decoration:
                                      InputDecoration(hintText: 'Title...'),
                                ),
                                TextFormField(
                                  maxLines: null,
                                  controller: widget._descriptionTextController,
                                  decoration: InputDecoration(
                                      hintText: 'Write your thought here...'),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}