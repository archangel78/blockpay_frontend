import 'dart:convert';
import 'dart:typed_data';
import 'package:blockpay_frontend/payment_pages/prepayment_pages/send_to_contact_page/send_to_contact.dart';
import 'package:http/http.dart' as http;
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/home_page/block_pay_home.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadContactsPage extends StatelessWidget {
  int colorIndex = 0;
  List<Color> allColors = [
    Color.fromARGB(255, 212, 7, 7),
    Color.fromARGB(255, 76, 175, 80),
    Color.fromARGB(255, 33, 150, 243),
    Color.fromARGB(255, 11, 200, 233),
    Color.fromARGB(255, 0, 188, 212),
    Color.fromARGB(255, 110, 77, 65),
    Color.fromARGB(255, 101, 55, 180),
    Color.fromARGB(255, 63, 81, 181),
    Color.fromARGB(255, 0, 150, 136),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send to Contact"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: FutureBuilder(
        future: getContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          }
          List<ContactsValues>? contacts = snapshot.data;
          if (contacts != null) {
            goToSendToContactsPage(context, contacts);
            return Text("Loading ...");
          }
          return Container(
            height: double.infinity,
            width: double.infinity,
            child: Text("Cannot send to contact at this time"),
          );
        },
      ),
    );
  }

  goToSendToContactsPage(
      BuildContext context, List<ContactsValues> contactValues) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SendToContactPage(contacts: contactValues)),
      );
    });
  }

  Future<List<ContactsValues>> getContacts() async {
    List<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    List<ContactsValues> contactValues = [];
    Set<String> contactNumbers = Set();

    for (int i = 0; i < contacts.length; i++) {
      var phones = contacts[i].phones;
      if (phones!.length > 0) {
        String? phoneNo = contacts[i].phones!.first.value;
        String? name = contacts[i].displayName;
        Uint8List? avatar = contacts[i].avatar;
        if (phoneNo != null && name != null && avatar != null) {
          final alphanumeric = RegExp(r'^[a-zA-Z ]+$');
          bool matches = alphanumeric.hasMatch(name);
          if (matches) {
            if (name.length > 8) {
              name = "${name.substring(0, 8)}...";
            }
            List<Item>? phones = contacts[i].phones;
            if (!contactNumbers.contains(phoneNo) && phones != null) {
              var nameParts = name.split(" ");
              if (nameParts.length > 0) {
                String initals = nameParts[0][0];
                if (nameParts.length > 1) {
                  initals += nameParts[1][0];
                }
                contactNumbers.add(phoneNo);
                contactValues.add(ContactsValues(
                    name: name,
                    phoneNo: phoneNo,
                    initals: initals,
                    phones: phones));
              }
            }
          }
        }
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    if (accessToken == null) {
      return contactValues;
    }
    var contactJson = jsonEncode(contactNumbers.toList());

    bool successfulReq = true;
    var url = HttpManager.getContactsEndpoint();
    var response = await http
        .post(url, headers: {"accessToken": accessToken}, body: contactJson)
        .catchError((error) {
      successfulReq = false;
    });
    if (!successfulReq) {
      for (int i = 0; i < contactValues.length; i++) {
        Color color = allColors[colorIndex % (allColors.length)];
        colorIndex++;
        contactValues[i].color = color;
      }
      return contactValues;
    }

    var body = jsonDecode(response.body);
    if (body["message"] != "successful") {
      for (int i = 0; i < contactValues.length; i++) {
        Color color = allColors[colorIndex % (allColors.length)];
        colorIndex++;
        contactValues[i].color = color;
      }
      return contactValues;
    }

    var indices = jsonDecode(body["indices"]);
    List<ContactsValues> orderedContactValues = [];

    for (int i = 0; i < indices.length; i++) {
      orderedContactValues.add(contactValues[indices[i]]);
    }

    for (int i = 0; i < orderedContactValues.length; i++) {
      Color color = allColors[colorIndex % (allColors.length)];
      colorIndex++;
      orderedContactValues[i].color = color;
    }
    return orderedContactValues;
  }
}
