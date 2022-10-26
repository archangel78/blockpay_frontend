import 'dart:convert';
import 'dart:typed_data';
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/home_page/components/invite_section.dart';
import 'package:blockpay_frontend/home_page/components/more_options.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/separator.dart';
import 'package:flutter/material.dart';
import 'components/people_details.dart';
import 'components/account_info.dart';
import 'components/header_widget.dart';
import 'components/text_header.dart';
import 'package:http/http.dart' as http;
import 'components/scroll_handle.dart';
import 'package:blockpay_frontend/home_page/components/quick_access_components.dart';

class ContactsValues {
  String phoneNo, name, initals;
  Color color;
  ContactsValues(
      {required this.phoneNo,
      required this.name,
      required this.initals,
      required this.color});
}

class BlockPayHome extends StatefulWidget {
  @override
  _BlockPayHomeState createState() => _BlockPayHomeState();
}

class _BlockPayHomeState extends State<BlockPayHome> {
  late Future<List<ContactsValues>> contacts;
  List<Color> allColors = [
    Color.fromARGB(255, 212, 7, 7),
    Color.fromARGB(255, 76, 175, 80),
    Color.fromARGB(255, 33, 150, 243),
    Color.fromARGB(255, 233, 11, 200),
    Color.fromARGB(255, 0, 188, 212),
    Color.fromARGB(255, 110, 77, 65),
    Color.fromARGB(255, 101, 55, 180),
    Color.fromARGB(255, 63, 81, 181),
    Color.fromARGB(255, 0, 150, 136),
  ];
  int colorIndex = 0;

  @override
  void initState() {
    super.initState();

    contacts = getContacts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contacts = getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getContactsPermission(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            }
            bool? gotPerm = snapshot.data;
            if (snapshot.hasData && snapshot.data == true) {
              return Container(
                color: Color.fromARGB(255, 18, 6, 92),
                child: Stack(
                  children: [
                    HeaderWidget(),
                    Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 110, right: 110, top: 100),
                          child: Container(
                            child: Image.asset(
                              "assets/images/blockpaylogo.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        QuickAccess(),
                      ],
                    ),
                    DraggableScrollableSheet(
                      initialChildSize: 0.66,
                      minChildSize: 0.6,
                      builder: (BuildContext context,
                          ScrollController myScrollController) {
                        return ListView.builder(
                          controller: myScrollController,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 12),
                                  ScrollHandle(),
                                  SizedBox(height: 20),
                                  TextHeader(headerValue: "People"),
                                  SizedBox(height: 20),
                                  FutureBuilder(
                                      future: contacts,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return CircularProgressIndicator();
                                        }
                                        List<ContactsValues>? contacts =
                                            snapshot.data;
                                        if (contacts != null) {
                                          return PeopleDetails(
                                            contacts: contacts,
                                            scrollController:
                                                myScrollController,
                                          );
                                        }
                                        return Text("Could not fetch contacts");
                                      }),
                                  SizedBox(height: 30),
                                  Separator(),
                                  SizedBox(height: 30),
                                  TextHeader(headerValue: "More Options"),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  MoreOptions(),
                                  SizedBox(height: 25),
                                  Separator(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextHeader(headerValue: "Account Info"),
                                  SizedBox(height: 30),
                                  AccountInfo(),
                                  SizedBox(height: 30),
                                  InviteSection(),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text("Please grant contacts permission from settings"),
            );
          }),
    );
  }

  Future<bool> getContactsPermission() async {
    var status = await Permission.contacts.request();
    return status.isGranted;
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = await prefs.getString("accountName");
    if (username != null) {
      return username;
    }
    return "";
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
            if (!contactNumbers.contains(phoneNo)) {
              var nameParts = name.split(" ");
              if (nameParts.length > 0) {
                String initals = nameParts[0][0];
                if (nameParts.length > 1) {
                  initals += nameParts[1][0];
                }
                Color color = allColors[colorIndex % (allColors.length)];
                colorIndex++;
                contactNumbers.add(phoneNo);
                contactValues.add(ContactsValues(
                    name: name,
                    phoneNo: phoneNo,
                    initals: initals,
                    color: color));
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
    print(response.body);

    return contactValues;
  }
}
