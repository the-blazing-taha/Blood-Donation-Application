import 'dart:io';
import 'package:blood/views/user/nearby_donors.dart';
import 'package:blood/views/user/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final navigatorKey = GlobalKey<NavigatorState>();

/// Initialize Firebase
Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: Platform.isAndroid
        ? const FirebaseOptions(
      apiKey: 'AIzaSyCuAwg9Y9kilszavw-eY32cV8bB5eL5P4w',
      appId: '1:873073858781:android:a0b01daed8a08310796334',
      messagingSenderId: '873073858781',
      projectId: 'blood-donation-applicati-30737',
      storageBucket: 'gs://blood-donation-applicati-30737.firebasestorage.app',
    )
        : null,
  );
}

/// Setup FCM Notifications
Future<void> setUpNotifications() async {
  final fcm = FirebaseMessaging.instance;
  await fcm.requestPermission();
  fcm.subscribeToTopic('requestNotifications');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Start showing the app immediately
  runApp(const SplashScreen());

  /// Initialize Firebase and other background tasks
  await initializeFirebase();
  await setUpNotifications();

  /// Start the main app
  runApp(const MyApp());
}

/// Splash screen to show while initializing
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Donation App',
      navigatorKey: navigatorKey,
      home: Wrapper(),
      routes: {
        NearbyDonors.route: (context) => const NearbyDonors(),
      },
    );
  }
}
