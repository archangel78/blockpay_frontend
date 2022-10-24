import 'dart:convert';

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
                  print(accountPageData.walletAddress);
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
              FutureBuilder(
                  future: getTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container(
                          alignment: Alignment.center,
                          height: 80,
                          width: 80,
                          child: CircularProgressIndicator());
                    }
                    List? transactions = snapshot.data;

                    if (snapshot.hasData && transactions != null) {
                      return (transactions.length == 0)
                          ? Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "No transactions found",
                                style: TextStyle(fontSize: 20),
                              ))
                          : SingleChildScrollView(
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: transactions.length,
                                  padding: EdgeInsets.all(10),
                                  itemBuilder: (context, index) {
                                    var transaction = transactions[index];
                                    bool debited =
                                        (transaction["fromAccount"] ==
                                            accountPageData.accountName);
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                TransactionPage(
                                                    amount: transaction[
                                                        "transactionAmount"],
                                                    name: (debited)
                                                        ? "${transaction["name"]}"
                                                        : "${transaction["fromName"]}",
                                                    time: transaction["ts"],
                                                    title: (debited)?"Payment Completed":"Payment Received",
                                                    toTitle: "Account Id",
                                                    toValue: (debited)
                                                        ? "${transaction["toAccount"]}"
                                                        : "${transaction["fromAccount"]}",
                                                    transactionId: transaction[
                                                        "transactionId"]),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        child: Container(
                                            height: 100,
                                            width: double.infinity,
                                            padding: EdgeInsets.all(15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      (debited)
                                                          ? "Money sent to "
                                                          : "Money received from ",
                                                      style: GoogleFonts.cairo(
                                                          fontSize: 15),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        (debited)
                                                            ? "${transaction["name"]}"
                                                            : "${transaction["fromName"]}",
                                                        style:
                                                            GoogleFonts.cairo(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  transaction[
                                                          "transactionAmount"] +
                                                      " SOL",
                                                  style: GoogleFonts.cairo(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )),
                                        color: (debited)
                                            ? Color.fromARGB(255, 237, 194, 194)
                                            : Color.fromARGB(
                                                255, 199, 247, 211),
                                      ),
                                    );
                                  }),
                            );
                    }
                    return Text("Could not fetch previous transactons");
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<List> getTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    if (accessToken == null) {
      return [];
    }
    bool successfulReq = true;
    var url = HttpManager.getTransactionHistoryEndpoint();
    var response = await http
        .get(url, headers: {"accessToken": accessToken}).catchError((error) {
      successfulReq = false;
    });

    if (!successfulReq) {
      return [];
    }
    var body = jsonDecode(response.body);
    if (body["message"] != "successful") {
      return [];
    }
    return body["transactions"];
  }
}
