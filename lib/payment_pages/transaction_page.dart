import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionPage extends StatelessWidget {
  String title, time, name, amount, toTitle, toValue, transactionId;
  @override
  TransactionPage(
      {Key? key,
      required this.title,
      required this.time,
      required this.name,
      required this.amount,
      required this.toTitle,
      required this.toValue,
      required this.transactionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Container(
          height: 420,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 35, 10, 199)),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Payment Completed",
                  style: GoogleFonts.cairo(fontSize: 22, color: Colors.white),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "at $time",
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 40,
                child: Icon(
                  MaterialCommunityIcons.check,
                  color: Colors.green,
                  size: 70,
                ),
              ),
              SizedBox(height: 15),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "To",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  name,
                  style: GoogleFonts.cairo(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  amount + " SOL",
                  style: GoogleFonts.cairo(
                      fontSize: 25,
                      color: Color.fromARGB(255, 118, 224, 114),
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "$toTitle: $toValue",
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "Transaction Id: $transactionId",
                    style: GoogleFonts.cairo(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
