import 'dart:typed_data';
import 'package:blockpay_frontend/offline_pay/offline_send_qr.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:blockpay_frontend/model/signinColorPallete.dart';
import 'package:blockpay_frontend/payment_pages/complete_payment.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class OfflinePayPage extends StatefulWidget {
  @override
  State<OfflinePayPage> createState() => _OfflinePayPageState();
}

class _OfflinePayPageState extends State<OfflinePayPage> {
  final accountIdController = TextEditingController();
  final amountController = TextEditingController();
  String signedToken = "";
  String ivString = "";
  String aName = "";

  String fullName = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send to Account Id"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomLeft,
              child: Text(
                "Enter the Account Id to send money to",
                style: GoogleFonts.cairo(fontSize: 20),
              ),
            ),
            buildTextField(MaterialCommunityIcons.account,
                "Account Id or Username", false, false, accountIdController),
            buildTextField(MaterialCommunityIcons.account, "Enter amount",
                false, true, amountController),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 50,
                width: 140,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 33, 0, 251),
                      Color.fromARGB(255, 32, 0, 242),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1))
                    ]),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isLoading = true;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "Send Now",
                          style:
                              GoogleFonts.robotoCondensed(color: Colors.white),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            (isLoading)
                ? FutureBuilder(
                    future: signTransaction(),
                    builder: (scontext, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasData && snapshot.data == true) {
                        goToPostPaymentPage(context);
                      }
                      return SizedBox(
                        height: 0,
                      );
                    })
                : SizedBox(
                    height: 0,
                  )
          ],
        ),
      ),
    );
  }

  goToPostPaymentPage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OfflineSendQr(
                  accountName: aName,
                  signedToken: signedToken,
                  ivString: ivString,
                )),
      );
    });
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      bool isNumber, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        obscureText: isPassword,
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
      ),
    );
  }

  Future<bool> signTransaction() async {
    String username = accountIdController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double amount = double.parse(amountController.text);
    if (username.length >= 3 && amount > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? privKeyId = prefs.getString("walletPrivId");
      String? accountName = prefs.getString("accountName");
      if (privKeyId == null || accountName == null) {
        return false;
      }
      String prover = privKeyId.substring(0, 5);
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('hh:mm d MMM yyyy').format(now);
      String trimmedAccountName = username;
      var toHashString =
          "{'toAccount': '${trimmedAccountName}', 'fromAccount': '$accountName', 'amount': '${amount}', 'prover': '$prover', 'expiryTime': '$formattedDate'}";

      final key = encrypt.Key.fromUtf8(privKeyId);
      final iv = encrypt.IV.fromSecureRandom(16);
      encrypt.AESMode mode = encrypt.AESMode.cbc;
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: mode));
      final encrypted = encrypter.encrypt(toHashString, iv: iv);
      signedToken = encrypted.base16;
      ivString = iv.base16;
      aName = accountName;
      print(signedToken);
      return true;
    }
    return false;
  }
}

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  final Uint8List unit8List = Uint8List.fromList(codeUnits);
  return unit8List;
}
