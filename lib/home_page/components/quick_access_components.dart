import 'package:blockpay_frontend/account_page/transaction_history.dart';
import 'package:blockpay_frontend/offline_pay/offline_landing.dart';
import 'package:blockpay_frontend/offline_pay/offline_pay_enter_details.dart';
import 'package:blockpay_frontend/payment_pages/prepayment_pages/qr_scan.dart';
import 'package:blockpay_frontend/payment_pages/prepayment_pages/send_to_contact_page/load_contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickAccess extends StatefulWidget {
  @override
  _QuickAccessState createState() => _QuickAccessState();
}

class _QuickAccessState extends State<QuickAccess> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QrScanPage()),
              );
            },
            child: Column(
              children: [
                CircleAvatar(
                  child: Icon(
                    Icons.center_focus_weak,
                    color: Color.fromARGB(255, 50, 122, 223),
                    size: 45,
                  ),
                  backgroundColor: Color.fromARGB(255, 18, 6, 92),
                  minRadius: 35.0,
                ),
                Text(
                  "Scan",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => LoadContactsPage(),
                ),
              );
            },
            child: Column(
              children: [
                CircleAvatar(
                  child: Icon(
                    Icons.people,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 45,
                  ),
                  backgroundColor: Color.fromARGB(255, 18, 6, 92),
                  minRadius: 35.0,
                ),
                Text(
                  "Send to Contact",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return OfflineLanding();
              }));
            },
            child: Column(
              children: [
                CircleAvatar(
                  child: Container(
                    child: Image.asset("assets/icons/thunderbolt.png"),
                    height: 38,
                    width: 38,
                  ),
                  backgroundColor: Color.fromARGB(255, 18, 6, 92),
                  minRadius: 35.0,
                ),
                Text(
                  "Offline pay",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: (() async {
              String username = await getUsername();
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Scaffold(
                      appBar: AppBar(
                        title: Text("Transaction History"),
                        backgroundColor: Color.fromARGB(255, 18, 6, 92),
                      ),
                      body: TransactionHistory(
                        username: username,
                      )),
                ),
              );
            }),
            child: Column(
              children: [
                CircleAvatar(
                  child: Container(
                    child: Image.asset("assets/icons/history.png"),
                    height: 38,
                    width: 38,
                  ),
                  backgroundColor: Color.fromARGB(255, 18, 6, 92),
                  minRadius: 35.0,
                ),
                Text(
                  "History",
                  style: TextStyle(color: Colors.white),
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
