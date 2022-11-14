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
  List<String> parts = s1.split(s2);
  return parts;
}

class BlockPayApp extends StatefulWidget {
  @override
  State<BlockPayApp> createState() => _BlockPayAppState();
}

@pragma('vm:entry-point')
void backgroundNotificationListener(Map<String, dynamic> data) {
  String messageText = data['message'] ?? "NULL";
  List<String> splitMessage = getSplitMessage(messageText, ":");
  print(splitMessage);
  print(splitMessage.length);
  if (splitMessage.length > 1) {
    String notificationTitle = splitMessage[0];
    String notificationText = splitMessage[1];

    Pushy.notify(notificationTitle, notificationText, data);

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

  Future<void> initPlatformState() async {
    Pushy.listen();
    Pushy.setNotificationIcon('icon.png');
    Pushy.toggleFCM(true);

    try {
      String deviceToken = await Pushy.register();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("notDeviceToken", deviceToken);

      setState(() {
        _deviceToken = deviceToken;
        _instruction =
            Platform.isAndroid ? '(copy from logcat)' : '(copy from console)';
      });
    } on PlatformException catch (error) {

      setState(() {
        _deviceToken = 'Registration failed';
      });
    }

    Pushy.toggleInAppBanner(true);
    Pushy.setNotificationListener(backgroundNotificationListener);

    Pushy.setNotificationClickListener((Map<String, dynamic> data) {
      print('Notification clicked: $data');

      String message = data['message'];
      List<String> splitMessage = getSplitMessage(message, ":");
      if (splitMessage.length == 9) {
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
