import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'package:web_practice/model/diary.dart';
import 'package:web_practice/model/user.dart';
import 'package:web_practice/screens/main_page.dart';
import 'package:web_practice/util/utils.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:html' as html;
import 'package:path/path.dart' as Path;
import 'package:web_practice/widgets/delete_entry_dialog.dart';

class UpdateEntryDialog extends StatefulWidget {
  const UpdateEntryDialog({
    Key? key,
    required this.diary,
    required TextEditingController titleTextController,
    required TextEditingController descriptionTextController,
    required CollectionReference<Map<String, dynamic>> linkReference,
  })  : _titleTextController = titleTextController,
        _descriptionTextController = descriptionTextController,
        _linkReference = linkReference,
        super(key: key);

  final Diary diary;
  final TextEditingController _titleTextController;
  final TextEditingController _descriptionTextController;
  final CollectionReference<Map<String, dynamic>> _linkReference;

  @override
  State<UpdateEntryDialog> createState() => _UpdateEntryDialogState();
}

class _UpdateEntryDialogState extends State<UpdateEntryDialog> {
  Image? _imageWidget;
  var _fileBytes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                    child: Text('Done'),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.green,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final user = FirebaseFirestore.instance
                          .collection('users')
                          .where('uid',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .get()
                          .then((value) => value.docs
                              .map((data) => MUser.fromDocument(data)))
                          .then((value) => value.first);

                      final fieldNotEmpty =
                          widget._titleTextController.text.isNotEmpty &&
                              widget._descriptionTextController.text.isNotEmpty;
                      final diaryTitleChanged = widget.diary.title !=
                          widget._titleTextController.text;
                      final diaryEntryChanged = widget.diary.entry !=
                          widget._descriptionTextController.text;

                      final diaryUpdate = diaryTitleChanged ||
                          diaryEntryChanged ||
                          _fileBytes != null;
                      if (fieldNotEmpty && diaryUpdate) {
                        final fs = firebase_storage.FirebaseStorage.instance;
                        final dateTime = DateTime.now();
                        final path = '$dateTime';

                        String? newUrl;
                        if (_fileBytes != null) {
                          final metadata = firebase_storage.SettableMetadata(
                              contentType: 'image/jpeg',
                              customMetadata: {'picked-file-path': path});

                          final task = await fs
                              .ref()
                              .child(
                                  'images/$path${await user.then((value) => value.uid)}')
                              .putData(_fileBytes!, metadata);
                          newUrl = await task.ref.getDownloadURL();
                        }

                        widget._linkReference.doc(widget.diary.id).update(Diary(
                              userId: await user.then((value) => value.uid),
                              title: widget._titleTextController.text,
                              author: await user.then((value) => value.name),
                              entryTime: Timestamp.fromDate(DateTime.now()),
                              photoUrls: newUrl ?? widget.diary.photoUrls,
                              entry: widget._descriptionTextController.text,
                            ).toMap());
                      }
                      Navigator.of(context).pop();
                    },
                  )),
            ]),
            SizedBox(
              height: 30,
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white12,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: () async {
                                  await getMultipleImageInfos();
                                },
                                splashRadius: 26,
                                icon: Icon(Icons.image_rounded)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: () async {
                                  final isDeleted = await showDialog(
                                    context: context,
                                    builder: (context) => DeleteEntryDialog(
                                        bookCollectionReference:
                                            widget._linkReference,
                                        diary: widget.diary),
                                  );
                                  if (isDeleted) {
                                    //TODO: fuck push to page which would decrease perfomance
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainPage(),
                                        ));
                                  }
                                },
                                splashRadius: 26,
                                color: Colors.red,
                                icon: Icon(Icons.delete_outline_rounded)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(formatDateFromTimestamp(
                                widget.diary.entryTime)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _imageWidget ??
                                    Image.network(widget.diary.photoUrls.isEmpty
                                        ? 'https://picsum.photos/400/200'
                                        : widget.diary.photoUrls),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Form(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: widget._titleTextController,
                                      decoration:
                                          InputDecoration(hintText: 'Title...'),
                                    ),
                                    TextFormField(
                                      maxLines: null,
                                      controller:
                                          widget._descriptionTextController,
                                      decoration: InputDecoration(
                                          hintText:
                                              'Write your thought here...'),
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

  Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    // String? mimeType = mime(Path.basename(mediaData.fileName!));
    // html.File mediaFile =
    //     html.File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

    setState(() {
      // _cloudFile = mediaFile;
      _fileBytes = mediaData.data;
      _imageWidget = Image.memory(mediaData.data!);
    });
  }
}
