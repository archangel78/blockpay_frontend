import 'package:flutter/material.dart';

class CheckContact extends StatelessWidget {
  String phoneNo;
  CheckContact({required this.phoneNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send to contact"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
    );
  }
}
