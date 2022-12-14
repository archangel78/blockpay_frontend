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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => AccountPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
