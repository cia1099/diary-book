import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:web_practice/model/diary.dart';
import 'package:web_practice/screens/login_page.dart';

import 'package:web_practice/screens/main_page.dart';

import 'screens/get_started_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //ref. https://stackoverflow.com/questions/70232931/firebaseoptions-cannot-be-null-when-creating-the-default-app
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyCOuqU7kTqHJk4K3jpbb9xPB1tl1XxtERg",
    appId: "1:406999155030:web:31cbb9a549eeba1b3f56f7",
    messagingSenderId: "406999155030",
    projectId: "flutter-web-128a1",
    authDomain: "flutter-web-128a1.firebaseapp.com",
    storageBucket: "flutter-web-128a1.appspot.com",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final userDiaryDataStream = FirebaseFirestore.instance
        .collection('diaries')
        .snapshots()
        .map((snap) =>
            snap.docs.map((docs) => Diary.fromDocument(docs)).toList());
    return MultiProvider(
      providers: [
        StreamProvider(
            create: (context) => FirebaseAuth.instance.authStateChanges(),
            initialData: null),
        StreamProvider<List<Diary>>(
            create: (context) => userDiaryDataStream, initialData: [])
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.green,
        ),
        home: LoginPage(),
      ),
    );
  }
}

class GetInfo extends StatelessWidget {
  const GetInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('diaries').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          return Material(
            child: ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot doc) => ListTile(
                          title: Text(doc.get('display_name')),
                          subtitle: Text(doc.get('profession')),
                        ))
                    .toList()),
          );
        });
  }
}
