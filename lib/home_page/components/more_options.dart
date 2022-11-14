import 'package:blockpay_frontend/payment_pages/prepayment_pages/send_account_id.dart';
import 'package:blockpay_frontend/payment_pages/prepayment_pages/send_to_phone.dart';
import 'package:blockpay_frontend/payment_pages/prepayment_pages/send_to_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return SendWalletPage();
              }));
            },
            child: Column(
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
          ),
          GestureDetector(
            onTap: (() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SendAccountIdPage()),
              );
            }),
            child: Column(
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  color: Color.fromARGB(255, 22, 83, 205),
                  size: 45,
                ),
                SizedBox(
                  height: 5,
                ),
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
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => SendPhoneNumberPage(),
                ),
              );
            },
            child: Column(
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
          ),
          GestureDetector(
            onTap: () async {
              String username = await getUsername();
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Scaffold(
                    appBar: AppBar(
                      title: Text("Scan to Pay Me"),
                      backgroundColor: Color.fromARGB(255, 18, 6, 92),
                    ),
                    body: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(15),
                          child: QrImage(
                            data: "blockpay:$username",
                            version: QrVersions.auto,
                            size: 260,
                            gapless: true,
                            foregroundColor:
                                const Color.fromARGB(255, 30, 3, 30),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Your Payment QR",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Dash(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Account ID: ${username}",
                          style: GoogleFonts.cairo(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Column(
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
          ),
        ],
      ),
    );
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = await prefs.getString("accountName");
    if (username != null) {
      return username;
    }
    return "";
  }
}
