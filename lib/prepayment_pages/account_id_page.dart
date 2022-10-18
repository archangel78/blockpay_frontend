import 'package:blockpay_frontend/home_page/components/login_components/login_signup.dart';
import 'package:blockpay_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: removeJwtTokens(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }
            return LoginSignupScreen();
          }),
    );
  }

  removeJwtTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool succ1 = await prefs.remove("accessToken");
    bool succ2 = await prefs.remove("refreshToken");
    print("successful");
    print(succ1);
    print(succ2);
  }
}
