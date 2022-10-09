import 'package:flutter/material.dart';

import 'components/block_pay_home.dart';
import 'components/login_components/login_signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginSignupScreen(),
    );
  }
}
