import 'package:blockpay_frontend/components/block_pay_home.dart';
import 'package:flutter/material.dart';

import 'components/login_components/login_signup.dart';
import 'package:blockpay_frontend/model/endpointModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: HttpManager.checkAccessToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
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
