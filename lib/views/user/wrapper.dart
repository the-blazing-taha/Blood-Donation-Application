import 'package:blood/views/admin/dashboard.dart';
import 'package:blood/views/auth/loginscreen.dart';
import 'package:blood/views/user/splash_screen.dart';
import 'package:blood/views/user/verifyemail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void setUpNotifications()  {
  final fcm = FirebaseMessaging.instance;
  fcm.requestPermission();
  fcm.subscribeToTopic('inventoryExpired');
}

class Wrapper extends StatefulWidget {

  const Wrapper({super.key});
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
// String? email = FirebaseAuth.instance.currentUser?.email;
  Future<void> saveUserFCMToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'fcmToken': fcmToken,
      });
      print("✅ FCM token saved to Firestore: $fcmToken");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                if(snapshot.data!.emailVerified){
                  if(snapshot.data?.email=='ahmad.taaha2002@gmail.com'){
                    setUpNotifications();
                    return Dashboard();
                  }
                  else {
                    return const SplashScreen();
                  }
                }
                else{
                  return const VerifyEmail();
                }
              }
              else{
                saveUserFCMToken();
                return const LoginScreen();
              }
            })
    );
  }
}