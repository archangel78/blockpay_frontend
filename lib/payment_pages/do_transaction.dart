import 'dart:convert';
import 'dart:typed_data';
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/payment_pages/transaction_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoTransaction extends StatefulWidget {
  String toAccount, amount;
  @override
  DoTransaction({Key? key, required this.toAccount, required this.amount})
      : super(key: key);

  @override
  State<DoTransaction> createState() => _DoTransactionState();
}

class _DoTransactionState extends State<DoTransaction> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: doPayment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Completing payment"),
                  backgroundColor: Color.fromARGB(255, 18, 6, 92),
                ),
                body: Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator()));
          }
          if (snapshot.hasData && snapshot.data == true) {
            return TransactionPage(
              amount: widget.amount,
              name: "Devakrishna C Nair",
              time: DateFormat('hh:mm d MMM yyyy').format(DateTime.now()),
              title: "Payment Completed",
              toTitle: "Account Id",
              toValue: widget.toAccount,
              transactionId: "XIDSISM838LSK2MDIIC8ISLJ2",
            );
          }
          return Scaffold(
              appBar: AppBar(
                title: Text("Completing payment"),
                backgroundColor: Color.fromARGB(255, 18, 6, 92),
              ),
              body: Text("Some Error occurred"));
        });
  }

  Future<bool> doPayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    String? privKeyId = prefs.getString("walletPrivId");
    String? accountName = prefs.getString("accountName");
    if (accessToken == null || privKeyId == null || accountName == null) {
      return false;
    }

    String prover = privKeyId.substring(0, 5);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('hh:mm d MMM yyyy').format(now);

    var toHashString =
        "{'toAccount': '${widget.toAccount}', 'fromAccount': '$accountName', 'amount': '${widget.amount}', 'prover': '$prover', 'expiryTime': '$formattedDate'}";

    final key = encrypt.Key.fromUtf8(privKeyId);
    final iv = encrypt.IV.fromSecureRandom(16);
    encrypt.AESMode mode = encrypt.AESMode.cbc;
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: mode));
    final encrypted = encrypter.encrypt(toHashString, iv: iv);

    var url = HttpManager.getCreateTransactionEndpoint();
    var response = await http.post(url, headers: {
      "Accesstoken": accessToken,
      "Transactionkey": encrypted.base16,
      "Iv": iv.base16,
      "Fromaccount": accountName,
      "Toaccount": widget.toAccount,
      "Amount": widget.amount
    });
    var body = jsonDecode(response.body);
    print(body);
    if (body["message"] == "successful") {
      return true;
    }
    return false;
  }
}

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  final Uint8List unit8List = Uint8List.fromList(codeUnits);
  return unit8List;
}
