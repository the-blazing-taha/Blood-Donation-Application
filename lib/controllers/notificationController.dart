// import 'package:blood/main.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class NotificationController{
//   final _firebaseMessaging = FirebaseMessaging.instance;
//
//   Future<void> initNotifications()async{
//       await _firebaseMessaging.requestPermission();
//
//       final fCMToken = await _firebaseMessaging.getToken();
//       print('Token: $fCMToken');
//       initPushNotification();
//   }
//
//   void handleMessage(RemoteMessage? message){
//     if(message == null) return;
//
//     navigatorKey.currentState?.pushNamed('notification_screen', arguments: message);
//   }
//
//   Future initPushNotification()async{
//       FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//   }
// }