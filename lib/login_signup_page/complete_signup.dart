import 'dart:convert';
import 'dart:math';
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/home_page/block_pay_home.dart';
import 'package:blockpay_frontend/model/signinColorPallete.dart';
import 'package:blockpay_frontend/payment_pages/do_transaction.dart';
import 'package:blockpay_frontend/payment_pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteSignUp extends StatefulWidget {
  final String username, emailId, password;
  @override
  const CompleteSignUp(
      {Key? key,
      required this.username,
      required this.emailId,
      required this.password})
      : super(key: key);

  State<CompleteSignUp> createState() => _CompleteSignUpState();
}

class _CompleteSignUpState extends State<CompleteSignUp> {
  bool isError = false;
  bool isLoading = false;
  String error = "Invalid Details";

  final nameFieldController = TextEditingController();
  final phoneFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Sign Up"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.bottomLeft,
            child: Text(
              "Enter the following information",
              style: GoogleFonts.roboto(
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildTextField(MaterialCommunityIcons.account, "Your Name", false,
              false, nameFieldController, TextInputType.name),
          buildUnfocussedTextField(
              MaterialCommunityIcons.phone, "+91", false, TextInputType.phone),
          buildTextField(MaterialCommunityIcons.phone, "Phone Number", false,
              false, phoneFieldController, TextInputType.phone),
          (isError)
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    error,
                    style: GoogleFonts.cairo(fontSize: 15, color: Colors.red),
                  ),
                )
              : SizedBox(
                  height: 10,
                ),
          SizedBox(
            height: 25,
          ),
          GestureDetector(
            onTap: () {
              String nameText = nameFieldController.text;
              String phoneText = phoneFieldController.text;
              if (nameText.length == 0) {
                setState(() {
                  isError = true;
                  isLoading = false;
                  error = "Please enter your name";
                });
                return;
              }
              if (phoneText.length == 0) {
                setState(() {
                  isError = true;
                  isLoading = false;
                  error = "Please enter your phone number";
                });
                return;
              }
              setState(() {
                isError = false;
                isLoading = true;
              });
            },
            child: Container(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                width: 185,
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
                        "Complete Signup",
                        style: GoogleFonts.robotoCondensed(color: Colors.white),
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
            height: 50,
          ),
          (isLoading)
              ? FutureBuilder(
                  future: CreateAccount(),
                  builder: (scontext, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasData && snapshot.data == true) {
                      goToHomePage(context);
                    }
                    return SizedBox(
                      height: 0,
                    );
                  })
              : SizedBox(
                  height: 0,
                )
        ]),
      ),
    );
  }

  goToHomePage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BlockPayHome()),
      );
    });
  }

  Future<bool> CreateAccount() async {
    String name = nameFieldController.text;
    String phone = phoneFieldController.text;
    bool successfulReq = true;
    var url = HttpManager.getCreateAccountEndpoint();
    var response = await http.post(url, headers: {
      "accountname": widget.username,
      "Emailid": widget.emailId,
      "password": widget.password,
      "Phoneno": phone,
      "Name": name,
      "Countrycode": "91"
    }).catchError((error) {
      successfulReq = false;
    });
    if (!successfulReq) {
      return false;
    }
    final body = jsonDecode(response.body);
    if (body["message"] != "successful") {
      setState(() {
        isError = true;
        isLoading = false;
        error = body["message"];
      });
      return false;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var value1 = await prefs.setString("accessToken", body["accessToken"]);
    var value2 = await prefs.setString("refreshToken", body["refreshToken"]);
    var value3 = await prefs.setString("walletPrivId", body["walletPrivId"]);
    var value4 = await prefs.setString("accountName", body["accountName"]);
    var value5 = await prefs.setString("walletPubKey", body["walletAddress"]);
    return true;
  }

  Widget buildTextField(
      IconData icon,
      String hintText,
      bool isPassword,
      bool isEmail,
      TextEditingController controller,
      TextInputType textInputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 15
      ),
      child: TextField(
        obscureText: isPassword,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
      ),
    );
  }

  Widget buildUnfocussedTextField(IconData icon, String hintText, bool isEmail,
      TextInputType textInputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
      ),
    );
  }
}
