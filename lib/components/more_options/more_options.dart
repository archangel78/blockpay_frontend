import 'package:flutter/material.dart';

class MoreOptions extends StatefulWidget {
  @override
  _MoreOptionsState createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Column(
            children: [
              Icon(
                Icons.wallet,
                color: Color.fromARGB(255, 22, 83, 205),
                size: 45,
              ),
              Column(
                children: [
                  Text(
                    "Send to",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    "Wallet",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              )
            ],
          ),
          Column(
            children: [
              Icon(
                Icons.account_circle_rounded,
                color: Color.fromARGB(255, 22, 83, 205),
                size: 45,
              ),
              SizedBox(height: 5,),
              Column(
                children: [
                  Text(
                    "Send to",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    "Account Id",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              )
            ],
          ),
          Column(
            children: [
              Icon(
                Icons.phone,
                color: Color.fromARGB(255, 22, 83, 205),
                size: 45,
              ),
              Column(
                children: [
                  Text(
                    "Send to",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    "Phone No",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              )
            ],
          ),
          Column(
            children: [
              Icon(
                Icons.qr_code,
                color: Color.fromARGB(255, 22, 83, 205),
                size: 45,
              ),
              Column(
                children: [
                  Text(
                    "Show my",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  Text(
                    "QR",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              )
            ],
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }
}
