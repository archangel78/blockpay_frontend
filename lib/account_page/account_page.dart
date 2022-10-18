import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logout_screen.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Text("Log Out"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LogOutScreen()),
          );
        },
      ),
    );
  }
}
