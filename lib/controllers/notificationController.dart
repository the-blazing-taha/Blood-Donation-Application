import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
    await NotificationController.instance.setupFlutterNotifications();
    await NotificationController.instance.showNotification(message);
}
class NotificationController {
  NotificationController._();
  static final NotificationController instance = NotificationController._();
  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;


  Future<void> initialize()async{
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await _setupMessageHandlers();
    final token=await _messaging.getToken();
    print('FCM Token: $token');

  }
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false);
    print('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }
    const channel = AndroidNotificationChannel(
        'high_importance_channel', 'high importance channel',
        description: 'This channel is used for important notifications',
        importance: Importance.high);
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettingsDarwin = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async {});
    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {});
    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  'high_importance_channel', 'High Importance Notification',
                  channelDescription:
                      'This channel is used for important notifications!',
                  importance: Importance.high,
                  priority: Priority.high,
                  icon: "@mipmap/ic_launcher"),
              iOS: const DarwinNotificationDetails(
                  presentAlert: true, presentBadge: true, presentSound: true)),
          payload: message.data.toString());
    }
  }


  Future<void> _setupMessageHandlers()async{
      FirebaseMessaging.onMessage.listen((message){
        showNotification(message);
      });
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
      final initialMessage = await _messaging.getInitialMessage();
      if(initialMessage!=null){
        _handleBackgroundMessage(initialMessage);
      }
  }
  void _handleBackgroundMessage(RemoteMessage message){
    if(message.data['type'] == 'chat'){

    }
  }
}
