import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/model/signinColorPallete.dart';
import 'package:blockpay_frontend/payment_pages/complete_payment.dart';

class SendWalletPage extends StatefulWidget {
  @override
  State<SendWalletPage> createState() => _SendWalletPageState();
}

class _SendWalletPageState extends State<SendWalletPage> {
  final walletAddressController = TextEditingController();
  final nameController = TextEditingController();

  String error = "Invalid Wallet Address";
  String fullName = "";
  String accountId = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send to Wallet Address"),
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
                "Enter the Wallet Address",
                style: GoogleFonts.cairo(fontSize: 20),
              ),
            ),
            buildTextField(MaterialCommunityIcons.wallet, "Wallet Address",
                false, false, walletAddressController),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomLeft,
              child: Text(
                "Enter a nickname",
                style: GoogleFonts.cairo(fontSize: 20),
              ),
            ),
            buildTextField(MaterialCommunityIcons.account, "Name", false, false,
                nameController),
            SizedBox(
              height: 10,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (() {
                setState(() {
                  isLoading = true;
                });
              }),
              child: Container(
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
                    future: checkWallet(),
                    builder: (scontext, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasData && snapshot.data == true) {
                        goToPostPaymentPage(context);
                      }
                      if (snapshot.hasData && snapshot.data == false) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            error,
                            style: GoogleFonts.cairo(
                                fontSize: 15, color: Colors.red),
                          ),
                        );
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CompletePaymentPage(
                  username: walletAddressController.text,
                  fullName: fullName,
                )),
      );
    });
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      bool isEmail, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        obscureText: isPassword,
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
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

  Future<bool> checkWallet() async {
    String wallet = walletAddressController.text;
    String name = nameController.text;
    if (wallet.length > 31 && wallet.length < 65) {
      if (name.length > 0) {
        return true;
      }
      error = "Enter a nickname";
      return false;
    }
    error = "Invalid Wallet Address";
    return false;
  }
}
