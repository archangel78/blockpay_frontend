import 'package:blockpay_frontend/home_page/block_pay_home.dart';
import 'package:flutter/material.dart';
import 'login_signup_page/login_signup.dart';
import 'package:blockpay_frontend/config/http_manager.dart';

void main() {
  runApp(BlockPayApp());
}

class BlockPayApp extends StatelessWidget {
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
