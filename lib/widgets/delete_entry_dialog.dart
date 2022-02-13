import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_practice/model/diary.dart';

class DeleteEntryDialog extends StatelessWidget {
  const DeleteEntryDialog({
    Key? key,
    required this.bookCollectionReference,
    required this.diary,
  }) : super(key: key);

  final CollectionReference<Map<String, dynamic>> bookCollectionReference;
  final Diary diary;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete Entry?',
        style: TextStyle(color: Colors.red),
      ),
      content: const Text(
          'Are you sure you want to delete the entry?\nThis action cannot reverse'),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () => bookCollectionReference
                .doc(diary.id)
                .delete()
                .then((value) => Navigator.of(context).pop(true)
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder:
                    //           (context) =>
                    //               MainPage(),
                    //     ))
                    ),
            child: const Text('Delete'))
      ],
    );
  }
}
