import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/views/sing_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/sing_in.dart';
import 'views/sing_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_dart/firebase_auth_dart.dart';
import 'package:flutter/foundation.dart';
import 'views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDXxEN3F-JZJpv5EbioINkgXgwfsHATopo",
            appId: "1:819075718473:web:b122dbf588cdc762578e98",
            messagingSenderId: "819075718473",
            projectId: "haiochatapp"));
  }

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
        ;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black87,
        primarySwatch: Colors.blue,
      ),
      home: _isSignedIn ? HomePage() : singIn(),
    );
  }
}
