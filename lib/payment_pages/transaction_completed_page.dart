import 'package:flutter/material.dart';

class TransactionCompleted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20)
        ,
      ),
    );
  }
}
