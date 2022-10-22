import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionPage extends StatelessWidget {
  String fromAccount, toAccount, amount;
  @override
  TransactionPage(
      {Key? key,
      required this.fromAccount,
      required this.toAccount,
      required this.amount})
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
              color: Color.fromARGB(255, 52, 34, 170)),
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
                  "at 12th December 12:50",
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
                  "Devakrishna C Nair",
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
              SizedBox(height: 15,),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Account Id: $toAccount",
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
                    "Transaction Id: cmFuZG9tIHRyYW5zYWN0aW9uIGlkIGdlbg==",
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
