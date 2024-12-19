import 'dart:io';
import 'package:blood/views/user/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';



void setLocale() {
  FirebaseAuth.instance
      .setLanguageCode('en'); // Set your desired locale, e.g., 'en' for English
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyA5deSHAnABXp7rZQtbCtk0aTO-A-XE9Ts',
              appId: '1:265277944690:android:65dcc9005385a7293423eb',
              messagingSenderId: '265277944690',
              projectId: 'blood-donors-and-acceptors',
              storageBucket: 'gs://blood-donors-and-acceptors.appspot.com'),
        )
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // home: NavigationExample(),
      home: Wrapper(),
    );
  }
}




