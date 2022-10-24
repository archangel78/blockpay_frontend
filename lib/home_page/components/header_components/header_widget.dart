import 'dart:convert';

import 'package:blockpay_frontend/account_page/account_page.dart';
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/payment_pages/prepayment_pages/qr_scan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountPageData {
  String accountName, walletAddress, balance;
  AccountPageData(
      {required this.accountName,
      required this.walletAddress,
      required this.balance});
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => QrScanPage(),
                ),
              );
            },
            child: CircleAvatar(
              child: Icon(
                Icons.center_focus_weak,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            child: CircleAvatar(
              child: Icon(Icons.people),
            ),
            onTap: () async {
              AccountPageData accountPageData = await getAccountPageData();
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => AccountPage(
                    accountPageData: accountPageData,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<AccountPageData> getAccountPageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    String? accountName = prefs.getString("accountName");
    String? walletAddress = prefs.getString("walletPubKey");
    print(accessToken);
    print(accountName);
    print(walletAddress);
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

    AccountPageData accountPageData =
        AccountPageData(accountName: accountName, walletAddress: walletAddress, balance: body["balance"]);
    return accountPageData;
  }
}
