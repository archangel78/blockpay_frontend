import 'dart:convert';

import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/payment_pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OfflineReceive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receive payment"),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: FutureBuilder(
              future: scanQr(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      width: double.infinity,
                      child: CircularProgressIndicator());
                }
                String? val = snapshot.data;
                if (val != null) {
                  if (val == "true") {
                    goToTransactionPage(context);
                  }
                  return Container(
                    child: Text(val),
                  );
                }
                return Container(
                  child: Text("Some error occurred"),
                );
              })),
    );
  }

  goToTransactionPage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                    body: Container(
                      child: Text("Payment successful"),
                      alignment: Alignment.center,
                    ),
                  )),
          ModalRoute.withName("/"));
    });
  }

  Future<String> scanQr() async {
    var status = await Permission.camera.request();
    if (status.isGranted || status.isLimited) {
      String? value = await scanner.scan();
      var url = HttpManager.getOfflinePayEndpoint();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString("accessToken");

      if (value != null && accessToken != null) {
        if (value.length > 20) {
          String uname_token_iv = value.substring(20);
          int col_index = uname_token_iv.indexOf(":");
          String uname = uname_token_iv.substring(0, col_index);

          String token_iv = uname_token_iv.substring(col_index + 1);
          col_index = token_iv.indexOf(":");
          String token = token_iv.substring(0, token_iv.indexOf(":"));
          String iv = token_iv.substring(col_index + 1);

          print(token);
          print(iv);
          print(uname);
          var response = await http.post(url, headers: {
            "Accesstoken": accessToken,
            "Transactionkey": token,
            "Iv": iv,
            "Fromaccount": uname
          });

          final body = jsonDecode(response.body);
          if (body["message"] == "successful") {
            return "true";
          }
        }
        print(value);
        return "Invalid Qr Code";
      } else {
        return "No Qr code scanned";
      }
    } else {
      return "Please provide camera permission to scan Qr";
    }
  }
}
