import 'package:blockpay_frontend/home_page/block_pay_home.dart';
import 'package:blockpay_frontend/payment_pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_signup_page/login_signup.dart';
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:pushy_flutter/pushy_flutter.dart';

void main() {
  runApp(BlockPayApp());
}

List<String> getSplitMessage(String s1, String s2) {
  int idx = s1.indexOf(s2);
  List<String> parts = [
    s1.substring(0, idx).trim(),
    s1.substring(idx + 1).trim()
  ];
  return parts;
}

class BlockPayApp extends StatefulWidget {
  @override
  State<BlockPayApp> createState() => _BlockPayAppState();
}

@pragma('vm:entry-point')
void backgroundNotificationListener(Map<String, dynamic> data) {
  // Print notification payload data
  print('Received notification: $data');

  // Attempt to extract the "message" property from the payload
  String messageText = data['message'] ?? "NULL";
  List<String> splitMessage = getSplitMessage(messageText, ":");
  if (splitMessage.length < 2) {
    String notificationTitle = splitMessage[0];
    String notificationText = splitMessage[1];

    // Android: Displays a system notification
    // iOS: Displays an alert dialog
    Pushy.notify(notificationTitle, notificationText, data);

    // Clear iOS app badge number
    Pushy.clearBadge();
  }
}

class _BlockPayAppState extends State<BlockPayApp> {
  String _deviceToken = 'Loading...';
  String _instruction = '(please wait)';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method
  Future<void> initPlatformState() async {
    // Start the Pushy service
    Pushy.listen();
    Pushy.setNotificationIcon('icon.png');

    // Enable FCM Fallback Delivery
    Pushy.toggleFCM(true);

    try {
      // Register the device for push notifications
      String deviceToken = await Pushy.register();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("notDeviceToken", deviceToken);
      // Print token to console/logcat
      print('Device token: $deviceToken');

      // Send the token to your backend server
      // ...

      // Update UI with token
      setState(() {
        _deviceToken = deviceToken;
        _instruction =
            Platform.isAndroid ? '(copy from logcat)' : '(copy from console)';
      });
    } on PlatformException catch (error) {
      // Print to console/logcat
      print('Error: ${error.message}');

      // Show error
      setState(() {
        _deviceToken = 'Registration failed';
        _instruction = '(restart app to try again)';
      });
    }

    // Enable in-app notification banners (iOS 10+)
    Pushy.toggleInAppBanner(true);

    // Listen for push notifications received
    Pushy.setNotificationListener(backgroundNotificationListener);

    // Listen for push notification clicked
    Pushy.setNotificationClickListener((Map<String, dynamic> data) {
      // Print notification payload data
      print('Notification clicked: $data');

      // Extract notification messsage
      String message = data['message'];
      List<String> splitMessage = getSplitMessage(message, ":");
      if (splitMessage.length == 9) {
        // Display an alert with the "message" payload value
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return TransactionPage(
                title: message[2],
                time: message[3],
                name: message[4],
                amount: message[5],
                toTitle: message[6],
                toValue: message[7],
                transactionId: message[8]);
          },
        );

        // Clear iOS app badge number
        Pushy.clearBadge();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: HttpManager.checkAccessToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Scaffold(
                  body: Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator()));
            }
            if (snapshot.data == "true") {
              return BlockPayHome();
            } else {
              return LoginSignupScreen();
            }
          }),
    );
  }
}
