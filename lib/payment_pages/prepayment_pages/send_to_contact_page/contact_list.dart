import 'dart:convert';

import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/home_page/block_pay_home.dart';
import 'package:blockpay_frontend/payment_pages/complete_payment.dart';
import 'package:blockpay_frontend/send_to_contact_page/check_contact.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContactsList extends StatelessWidget {
  final List<ContactsValues> contacts;
  Function() reloadContacts;
  ContactsList({Key? key, required this.contacts, required this.reloadContacts})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          ContactsValues contact = contacts[index];

          return InkWell(
            onTap: () async {
              VerifyPhoneResponse verifyPhoneResponse =
                  await verifyPhone(contact.phoneNo);
              if (verifyPhoneResponse.valid) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return CompletePaymentPage(
                      username: verifyPhoneResponse.accountName,
                      fullName: verifyPhoneResponse.fullName);
                }));
              } else {
                Fluttertoast.showToast(
                    msg: "This user does not have an account",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Color.fromARGB(255, 18, 6, 92),
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            child: ListTile(
              title: Text(contact.name),
              subtitle: Text(contact.phoneNo),
              leading: CircleAvatar(
                child: Text(
                  contact.initals,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                backgroundColor: contact.color,
                radius: 27,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<VerifyPhoneResponse> verifyPhone(String phoneNo) async {
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
