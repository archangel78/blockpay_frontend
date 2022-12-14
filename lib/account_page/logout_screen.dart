import 'package:blockpay_frontend/login_signup_page/login_signup.dart';
import 'package:blockpay_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: removeJwtTokens(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          }
          goToLoginPage(context);
          return Scaffold(body: Text("Signing out"));
        });
  }

  goToLoginPage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginSignupScreen()),
          ModalRoute.withName("/"));
    });
  }

  removeJwtTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
    await prefs.remove("refreshToken");
    await prefs.remove("walletPrivId");
    await prefs.remove("accountName");
    await prefs.remove("walletPubKey");
  }
}
