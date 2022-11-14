import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HandleNotification {
  static initalizeNotificationHandler() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken(
      vapidKey:
          "BMlIc5Q5aee7U_Vj5VFT-9O3-57IFU5LPZ_Jp1MaSHU3cOEe8d_zBPE9NHlAvOPP48wduvUjQpxTTTwT8arG-Rk",
    );
    print(token);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'Transaction Notificatiosn', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();
    // await flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      String? description = channel.description;
      String? smallIcon = android?.smallIcon;
      if (notification != null &&
          android != null &&
          description != null &&
          smallIcon != null) {
        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: description,
                  icon: smallIcon,
                  // other properties...
                ),
              ));
        }
      }
    });
  }
}
