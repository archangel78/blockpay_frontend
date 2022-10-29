import 'package:blockpay_frontend/home_page/block_pay_home.dart';
import 'package:blockpay_frontend/payment_pages/prepayment_pages/send_to_contact_page/contact_list.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SendToContactPage extends StatefulWidget {
  List<ContactsValues> contacts;
  SendToContactPage({required this.contacts});
  @override
  _SendToContactPageState createState() => _SendToContactPageState();
}

class _SendToContactPageState extends State<SendToContactPage> {
  List<ContactsValues> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();
  bool contactsLoaded = true;

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      searchController.addListener(() {
        filterContacts();
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  filterContacts() async {
    List<ContactsValues> _contacts = [];
    _contacts.addAll(widget.contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.name.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.phones.firstWhere((phn) {
          String? value = phn.value;
          if (value != null) {
            String phnFlattened = flattenPhoneNumber(value);
            return phnFlattened.contains(searchTermFlatten);
          }
          return false;
        }, orElse: () => Item(value: ""));

        return phone.value != "";
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist =
        ((isSearching == true && contactsFiltered.length > 0) ||
            (isSearching != true));

    return Scaffold(
      appBar: AppBar(
        title: Text("Send to Contact"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    labelText: 'Search',
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                      color: Color.fromARGB(255, 18, 6, 92),
                    )),
                    prefixIcon: Icon(Icons.search,
                        color: Color.fromARGB(255, 18, 6, 92),)),
              ),
            ),
            contactsLoaded
                ? listItemsExist
                    ? ContactsList(
                        reloadContacts: () {
                          widget.contacts;
                        },
                        contacts:
                            isSearching ? contactsFiltered : widget.contacts,
                      )
                    : Container(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          isSearching
                              ? 'No search results to show'
                              : 'No contacts exist',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ))
                : Container(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
