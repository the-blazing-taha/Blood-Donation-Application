import 'dart:io';
import 'package:blood/views/user/allrequests.dart';
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
void _handleMessage(RemoteMessage message) {
  final docId = message.data['docId'];
  if (docId != null) {
    navigatorKey.currentState?.pushNamed('/requestDetails', arguments: {'docId': docId});
  }
}

Future<void> setupInteractedMessage() async {
  // Handle the case when the app is terminated
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }
  // Foreground and background message click
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

/// Setup FCM Notifications
Future<void> setUpNotifications() async {
  final fcm = FirebaseMessaging.instance;
  await fcm.requestPermission();
  fcm.subscribeToTopic('requestNotifications');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeFirebase();
  await setUpNotifications();

  // Check if the app was opened via a notification
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();


  runApp(MyApp(initialMessage: initialMessage));
}


/// Splash screen to show while initializing
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true, // or false if you want to prevent resizing
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final RemoteMessage? initialMessage;

  const MyApp({super.key, this.initialMessage});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Blood Donation App',
      initialRoute: _getInitialRoute(),
      routes: {
        '/': (context) => const Wrapper(), // Default route (shows splash inside)
        '/requestDetails': (context) => AllRequests(),
      },
    );
  }

  String _getInitialRoute() {
    if (initialMessage?.data['docId'] != null) {
      // Store the docId somewhere if needed
      Future.microtask(() {
        navigatorKey.currentState?.pushNamed(
          '/requestDetails',
          arguments: {'docId': initialMessage!.data['docId']},
        );
      });
    }
    return '/'; // Return to Wrapper, but redirect above will fire if needed
  }
}
