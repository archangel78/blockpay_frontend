import 'package:blockpay_frontend/home_page/block_pay_home.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  final List<ContactsValues> contacts;
  Function() reloadContacts;
  ContactsList(
      {Key? key, required this.contacts, required this.reloadContacts})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          ContactsValues contact = contacts[index];

          return ListTile(
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
          );
        },
      ),
    );
  }
}
