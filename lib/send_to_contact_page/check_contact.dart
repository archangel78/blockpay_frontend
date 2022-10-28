import 'dart:convert';

import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/payment_pages/complete_payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerifyPhoneResponse {
  bool valid;
  String phoneNo, fullName, accountName;
  VerifyPhoneResponse(
      {required this.valid,
      required this.phoneNo,
      required this.fullName,
      required this.accountName});
}

class CheckContact extends StatelessWidget {
  String phoneNo;
  CheckContact({required this.phoneNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send to contact"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: FutureBuilder(
          future: verifyPhone(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Scaffold(
                  body: Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator()));
            }
            VerifyPhoneResponse? verifyPhoneResponse = snapshot.data;
            if (verifyPhoneResponse != null && verifyPhoneResponse.valid) {
              goToPaymentCompletionPage(context, verifyPhoneResponse);
              return Container(
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text("Starting Transaction"));
            }
            return Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text("This user does not use Blockpay, Invite them now!"),
                  ElevatedButton(onPressed: () {}, child: Text("Invite Now"))
                ],
              ),
            );
          }),
    );
  }

  goToPaymentCompletionPage(
      BuildContext context, VerifyPhoneResponse verifyPhoneResponse) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => CompletePaymentPage(
            username: verifyPhoneResponse.accountName,
            fullName: verifyPhoneResponse.fullName,
          ),
        ),
      );
    });
  }

  Future<VerifyPhoneResponse> verifyPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");

    if (accessToken != null) {
      var url = HttpManager.getVerifyPhoneEndpoint();
      bool successfulReq = true;

      var response = await http.get(url, headers: {
        "Accesstoken": accessToken,
        "Phoneno": phoneNo,
      }).catchError((error) {
        successfulReq = false;
      });
      if (successfulReq) {
        final body = jsonDecode(response.body);
        if (body["message"] == "successful") {
          return VerifyPhoneResponse(
              valid: true,
              phoneNo: phoneNo,
              fullName: body["fullName"],
              accountName: body["accountName"]);
        } else {
          print(body["message"]);
        }
      }
    }
    return VerifyPhoneResponse(
        valid: false, phoneNo: "", fullName: "", accountName: "");
  }
}
