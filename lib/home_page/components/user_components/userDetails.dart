import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blockpay_frontend/model/userModel.dart';

class UserDetails extends StatefulWidget {
  final ScrollController controller;

  const UserDetails({Key? key, required this.controller}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  List<Contact> contacts = [];
  @override
  void initState(){
    super.initState();
    getAllContacts();
  }
  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: 6,
        controller: widget.controller,
        itemBuilder: (context, i) {
          return GridTile(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: MemoryImage(contacts[i].avatar?? Uint8List(0)),
                  radius: 30,
                ),
                SizedBox(height: 2),
                Text(
                  contacts[i].displayName ?? "Unavailable",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
