import 'dart:convert';

import 'package:blockpay_frontend/account_page/account_page.dart';
import 'package:blockpay_frontend/account_page/transaction_history.dart';
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/home_page/components/header_components/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class CashUtils extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              String username = await getUsername();
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Scaffold(
                      appBar: AppBar(
                        title: Text("Transaction History"),
                        backgroundColor: Color.fromARGB(255, 18, 6, 92),
                      ),
                      body: TransactionHistory(
                        username: username,
                      )),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.history,
                  color: Colors.blue,
                  size: 25,
                ),
                SizedBox(width: 20),
                Text(
                  "See all payment activity",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(width: 100),
                Icon(Icons.arrow_forward_ios, size: 15),
              ],
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              AccountPageData accountPageData = await getAccountPageData();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AccountPage(accountPageData: accountPageData)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.account_balance,
                  color: Colors.blue,
                  size: 25,
                ),
                SizedBox(width: 20),
                Text(
                  "Check account balance",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(width: 100),
                Icon(Icons.arrow_forward_ios, size: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = await prefs.getString("accountName");
    if (username != null) {
      return username;
    }
    return "";
  }

  Future<AccountPageData> getAccountPageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    String? accountName = prefs.getString("accountName");
    String? walletAddress = prefs.getString("walletPubKey");
    if (accountName == null || walletAddress == null || accessToken == null) {
      return AccountPageData(accountName: "", walletAddress: "", balance: "");
    }
    bool successfulReq = true;
    var url = HttpManager.getGetBalanceEndpoint();
    var response = await http
        .get(url, headers: {"accessToken": accessToken}).catchError((error) {
      successfulReq = false;
    });

    if (!successfulReq) {
      return AccountPageData(accountName: "", walletAddress: "", balance: "");
    }

    var body = jsonDecode(response.body);
    if (body["message"] != "successful") {
      return AccountPageData(accountName: "", walletAddress: "", balance: "");
    }

    AccountPageData accountPageData = AccountPageData(
        accountName: accountName,
        walletAddress: walletAddress,
        balance: body["balance"]);
    return accountPageData;
  }
}
