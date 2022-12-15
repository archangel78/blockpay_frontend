import 'package:blockpay_frontend/offline_pay/offline_pay_enter_details.dart';
import 'package:blockpay_frontend/offline_pay/offline_receive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OfflineLanding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offline Pay"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 100,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return OfflinePayPage();
                      }));
                    },
                    child: Text(
                      "Send Offline Transaction",
                      style: GoogleFonts.cairo(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 18, 6, 92)),
                    )),
              ),
              SizedBox(
                height: 100,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return OfflineReceive();
                      }));
                    },
                    child: Text(
                      "Receive Transaction",
                      style: GoogleFonts.cairo(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 18, 6, 92)),
                    )),
              ),
            ],
          )),
    );
  }
}
