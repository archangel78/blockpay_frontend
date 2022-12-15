import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OfflineSendQr extends StatelessWidget {
  String signedToken;
  String ivString;
  String accountName;
  OfflineSendQr({required this.signedToken, required this.ivString, required this.accountName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offline Send QR"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "Ask the receiver to scan this QR by going to 'Receive payments' section in offline pay in their app",
              style: GoogleFonts.cairo(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          QrImage(
            data: "blockpay_offlinepay:"+accountName+":"+signedToken+":"+ivString,
            version: QrVersions.auto,
            size: 260,
            gapless: true,
            foregroundColor: const Color.fromARGB(255, 30, 3, 30),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Warning: As soon as someone scans this QR from their app, the transaction will be executed",
            style: GoogleFonts.cairo(fontSize: 20, color: Colors.red),
          )
        ]),
      ),
    );
  }
}
