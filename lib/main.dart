import 'dart:io';
import 'package:blood/controllers/notificationController.dart';
import 'package:blood/views/user/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';



void setLocale() {
  FirebaseAuth.instance
      .setLanguageCode('en'); // Set your desired locale, e.g., 'en' for English
}
// final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCuAwg9Y9kilszavw-eY32cV8bB5eL5P4w',
              appId: '1:873073858781:android:a0b01daed8a08310796334',
              messagingSenderId: '873073858781',
              projectId: 'blood-donation-applicati-30737',
              storageBucket: 'gs://blood-donation-applicati-30737.firebasestorage.app'),
        )
      : await Firebase.initializeApp();
  // await NotificationController().initNotifications();
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

