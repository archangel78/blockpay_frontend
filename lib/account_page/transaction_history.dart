import 'dart:convert';
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/payment_pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TransactionHistory extends StatelessWidget {
  String username;
  TransactionHistory({required this.username});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                              (transaction["fromAccount"] == username);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      TransactionPage(
                                          amount:
                                              transaction["transactionAmount"],
                                          name: (debited)
                                              ? "${transaction["name"]}"
                                              : "${transaction["fromName"]}",
                                          time: transaction["ts"],
                                          title: (debited)
                                              ? "Payment Completed"
                                              : "Payment Received",
                                          toTitle: "Account Id",
                                          toValue: (debited)
                                              ? "${transaction["toAccount"]}"
                                              : "${transaction["fromAccount"]}",
                                          transactionId:
                                              transaction["transactionId"]),
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
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            (debited)
                                                ? "Money sent to "
                                                : "Money received from ",
                                            style:
                                                GoogleFonts.cairo(fontSize: 15),
                                          ),
                                          Container(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              (debited)
                                                  ? "${transaction["name"]}"
                                                  : "${transaction["fromName"]}",
                                              style: GoogleFonts.cairo(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        transaction["transactionAmount"] +
                                            " SOL",
                                        style: GoogleFonts.cairo(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                              color: (debited)
                                  ? Color.fromARGB(255, 240, 207, 207)
                                  : Color.fromARGB(255, 207, 240, 212),
                            ),
                          );
                        }),
                  );
          }
          return Text("Could not fetch previous transactons");
        });
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
