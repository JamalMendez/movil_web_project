import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_proyect/views/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? FirebaseOptions(
              apiKey: "AIzaSyDW97BanLCnAMtAetyVHt9Ljo1vuLWu6Is",
              authDomain: "multi-sotore-app-v2.firebaseapp.com",
              projectId: "multi-sotore-app-v2",
              storageBucket: "multi-sotore-app-v2.appspot.com",
              messagingSenderId: "298702164343",
              appId: "1:298702164343:web:d76878262db71767879172")
          : null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}
