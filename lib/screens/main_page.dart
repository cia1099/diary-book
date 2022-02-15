import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:web_practice/model/diary.dart';
import 'package:web_practice/model/user.dart';
import 'package:web_practice/services/service.dart';
import 'package:web_practice/widgets/create_profile.dart';
import 'package:web_practice/widgets/diary_list_view.dart';
import 'package:web_practice/widgets/write_diary_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _dropDownText;
  DateTime? selectedDate; // = DateTime.now();
  var userDiaryFilterEntriesList;
  // final _listOfDiaries = <Diary>[]

  get onSelectionChanged => null;
  @override
  Widget build(BuildContext context) {
    final _listOfDiaries = context
        .watch<List<Diary>>()
        .where((diary) => selectedDate == null
            ? DateTime.now().isAfter(diary.entryTime.toDate())
            : selectedDate!
                    .add(const Duration(days: 1))
                    .isAfter(diary.entryTime.toDate()) &&
                selectedDate!.isBefore(diary.entryTime.toDate()))
        .toList();
    //final _listOfDiaries = Provider.of<List<Diary>>(context);
    final _titleTextController = TextEditingController();
    final _descriptionTextController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 4,
        toolbarHeight: 100,
        title: Row(
          children: [
            Text(
              'Diary',
              style: TextStyle(fontSize: 39, color: Colors.blueGrey.shade400),
            ),
            const Text(
              'Book',
              style: TextStyle(fontSize: 39, color: Colors.green),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton(
                  items: const ['Latest', 'Earliest']
                      .map((item) => DropdownMenuItem(
                            child: Text(
                              item,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            value: item,
                          ))
                      .toList(),
                  hint: _dropDownText == null
                      ? const Text('Select')
                      : Text(_dropDownText!),
                  onChanged: (value) {
                    setState(() {
                      _dropDownText = value.toString();
                    });
                  },
                ),
              ),
              //TODO: create profile
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return CircularProgressIndicator.adaptive();

                  final usersListStream = snapshot.data!.docs
                      .map((doc) => MUser.fromDocument(doc))
                      .where((user) =>
                          user.uid == FirebaseAuth.instance.currentUser!.uid)
                      .toList();
                  final curUser = usersListStream[0];
                  return CreateProfile(currentUser: curUser);
                },
              ),
            ],
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border(
                        right: BorderSide(width: 0.4, color: Colors.blueGrey))),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: SfDateRangePicker(
                        toggleDaySelection: true,
                        onSelectionChanged: (dateRangePickerSelection) {
                          setState(() {
                            selectedDate = dateRangePickerSelection.value;
                            // if (selectedDate != null) {
                            //   _listOfDiaries.clear();
                            //   userDiaryFilterEntriesList = DiaryService()
                            //       .getSameDateDiary(
                            //           Timestamp.fromDate(selectedDate!)
                            //               .toDate(),
                            //           FirebaseAuth.instance.currentUser!.uid)
                            //       .then((items) {
                            //     for (var element in items) {
                            //       _listOfDiaries.add(element);
                            //     }
                            //     setState(() {});
                            //   });
                            // }
                          });
                          // print(dateRangePickerSelection.value.toString());
                        },
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Card(
                          elevation: 4,
                          child: TextButton.icon(
                            icon: Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.greenAccent,
                            ),
                            label: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Write New',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => WriteDiaryDialog(
                                  selectedDate: selectedDate ?? DateTime.now(),
                                  titleTextController: _titleTextController,
                                  descriptionTextController:
                                      _descriptionTextController),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 3,
              child: DiaryListView(
                  selectedDate: selectedDate ?? DateTime.now(),
                  listOfDiaries: _listOfDiaries)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => WriteDiaryDialog(
                selectedDate: selectedDate ?? DateTime.now(),
                titleTextController: _titleTextController,
                descriptionTextController: _descriptionTextController)),
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
