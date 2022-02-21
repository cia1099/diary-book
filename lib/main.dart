import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:web_practice/model/diary.dart';
import 'package:web_practice/model/global.dart';
import 'package:web_practice/screens/login_page.dart';

import 'package:web_practice/screens/main_page.dart';
import 'package:web_practice/screens/page_not_found.dart';

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
        StreamProvider<User?>(
            create: (context) => FirebaseAuth.instance.authStateChanges(),
            initialData: null),
        StreamProvider<List<Diary>>(
            create: (context) => userDiaryDataStream, initialData: []),
        ChangeNotifierProvider<GlobalVariable>(
            create: (context) => GlobalVariable()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: settings,
          builder: (context) => RouteController(settingName: settings.name!),
        ),
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => PageNotFound(),
        ),
        // home: LoginPage(),
      ),
    );
  }
}

class RouteController extends StatelessWidget {
  const RouteController({Key? key, required this.settingName})
      : super(key: key);
  final String settingName;

  @override
  Widget build(BuildContext context) {
    final isUserSignedIn = context.read<User?>() != null;

    final signedInGotoMain =
        isUserSignedIn && (settingName == '/main' || settingName == '/login');
    final notSignedInGotoMain = !isUserSignedIn;
    if (settingName == '/')
      return GettingStartPage();
    else if ((settingName == '/main' || settingName == '/login') &&
        notSignedInGotoMain)
      return LoginPage();
    else if (signedInGotoMain)
      return MainPage();
    else
      return PageNotFound();
  }
}
