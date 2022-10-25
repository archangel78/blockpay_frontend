import 'dart:convert';

import 'package:blockpay_frontend/account_page/transaction_history.dart';
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/home_page/components/header_components/header_widget.dart';
import 'package:blockpay_frontend/payment_pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'logout_screen.dart';

class AccountPage extends StatelessWidget {
  AccountPageData accountPageData;
  AccountPage({required this.accountPageData});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.center,
                child: QrImage(
                  data: "blockpay:${accountPageData.accountName}",
                  version: QrVersions.auto,
                  size: 260,
                  gapless: true,
                  foregroundColor: const Color.fromARGB(255, 30, 3, 30),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Your Payment QR",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Dash(),
              SizedBox(
                height: 10,
              ),
              Text(
                "Account ID: ${accountPageData.accountName}",
                style: GoogleFonts.cairo(fontSize: 20),
              ),
              GestureDetector(
                onTap: () async {
                  await Clipboard.setData(
                      ClipboardData(text: accountPageData.walletAddress));
                  Fluttertoast.showToast(
                      msg: "Copied Wallet Address",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Color.fromARGB(255, 18, 6, 92),
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: Text(
                  (accountPageData.walletAddress.length > 6)
                      ? "Wallet Address(Tap to copy): ${accountPageData.walletAddress.substring(0, 5)}...."
                      : "Wallet Address (Tap to copy): NA",
                  style: GoogleFonts.cairo(fontSize: 20),
                ),
              ),
              Text(
                "Balance: ${accountPageData.balance} SOL",
                style: GoogleFonts.cairo(fontSize: 20),
              ),
              Container(
                child: ElevatedButton(
                  child: Text("Log Out"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 18, 6, 92),
                  )),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LogOutScreen()),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Dash(),
              Padding(
                padding: EdgeInsets.only(top: 25, left: 25, right: 25),
                child: Row(
                  children: [
                    Text(
                      "Transaction History",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              TransactionHistory(username: accountPageData.accountName)
            ],
          ),
        ),
      ),
    );
  }
}
