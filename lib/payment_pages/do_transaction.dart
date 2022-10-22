import 'package:flutter/material.dart';

class DoTransaction extends StatefulWidget {
  String fromAccount, toAccount, amount;
  @override
  DoTransaction(
      {Key? key,
      required this.fromAccount,
      required this.toAccount,
      required this.amount})
      : super(key: key);

  @override
  State<DoTransaction> createState() => _DoTransactionState();
}

class _DoTransactionState extends State<DoTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
