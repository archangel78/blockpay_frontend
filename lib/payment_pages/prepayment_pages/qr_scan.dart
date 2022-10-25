import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/model/signinColorPallete.dart';
import 'package:blockpay_frontend/payment_pages/complete_payment.dart';

class QrScanPage extends StatefulWidget {
  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan a QR"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: Container(
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
                if (val.substring(0, 9) == "blockpay:") {
                  String uname = val.substring(9);
                  goToPostPaymentPage(context, uname);
                }

                return Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    width: double.infinity,
                    child: Text(
                      val,
                      style: GoogleFonts.robotoCondensed(fontSize: 25),
                    ));
              }
              return Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  width: double.infinity,
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        "Failed to scan QR Code",
                        style: GoogleFonts.robotoCondensed(fontSize: 25),
                      )));
            }),
      ),
    );
  }

  Future<String> scanQr() async {
    var status = await Permission.camera.status;
    if (status.isGranted || status.isLimited) {
      String? value = await scanner.scan();
      if (value != null) {
        if (value.length > 12) {
          bool validQr = await checkAccount(value.substring(9));
          if (validQr) {
            return value;
          }
        }
        return "Invalid Qr Code";
      } else {
        return "No Qr code scanned";
      }
    } else {
      return "Please provide camera permission to scan Qr";
    }
  }

  goToPostPaymentPage(BuildContext context, String uname) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CompletePaymentPage(username: uname)),
      );
    });
  }

  Future<bool> checkAccount(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = await prefs.getString("accessToken");
    if (accessToken == null) {
      return false;
    }

    bool successfulReq = true;
    var url = HttpManager.getCheckAccountEndpoint();

    var response = await http.get(url, headers: {
      "Accesstoken": accessToken,
      "Username": username,
    }).catchError((error) {
      successfulReq = false;
    });
    if (!successfulReq) {
      return false;
    }
    final body = jsonDecode(response.body);
    if (body["message"] == "successful") {
      return true;
    }
    return false;
  }
}
