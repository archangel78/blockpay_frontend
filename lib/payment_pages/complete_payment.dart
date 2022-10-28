import 'dart:convert';
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:blockpay_frontend/model/signinColorPallete.dart';
import 'package:blockpay_frontend/payment_pages/do_transaction.dart';
import 'package:blockpay_frontend/payment_pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletePaymentPage extends StatefulWidget {
  final String username, fullName;
  @override
  const CompletePaymentPage({Key? key, required this.username, required this.fullName})
      : super(key: key);

  State<CompletePaymentPage> createState() => _CompletePaymentPageState();
}

class _CompletePaymentPageState extends State<CompletePaymentPage> {
  bool isError = false;
  bool isLoading = false;
  String error = "Invalid Amount";

  final amountFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Payment"),
        backgroundColor: Color.fromARGB(255, 18, 6, 92),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              "Enter amount (SOL) to send",
              style: GoogleFonts.roboto(
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildTextField(MaterialCommunityIcons.wallet, "Amount", false, false,
              amountFieldController),
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
            height: 30,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "Sending money to",
              style: GoogleFonts.robotoCondensed(
                fontSize: 32,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              widget.fullName,
              style:
                  GoogleFonts.robotoCondensed(fontSize: 32, color: Colors.blue),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          GestureDetector(
            onTap: () {
              String amountText = amountFieldController.text;
              try {
                double amount = double.parse(amountText);
                if (amount < 0.01 || amountFieldController.text == "") {
                  setState(() {
                    isError = true;
                    isLoading = false;
                    error = "Amount should be greater than 0.01 SOL";
                  });
                  return;
                }
                setState(() {
                  isError = false;
                  isLoading = true;
                });
              } catch (e) {
                setState(() {
                  isError = true;
                  isLoading = false;
                  error = "Amount should be greater than 0.01 SOL";
                });
              }
            },
            child: Container(
              alignment: Alignment.center,
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
                  future: verifyAmount(),
                  builder: (scontext, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasData && snapshot.data == true) {
                      goToPaymentCompletionPage(context);
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

  goToPaymentCompletionPage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DoTransaction(toAccount: widget.username, amount: amountFieldController.text)),
      );
    });
  }

  Future<bool> verifyAmount() async {
    String username = widget.username;
    double amount = double.parse(amountFieldController.text);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    if (accessToken == null) {
      setState(() {
        isError = true;
        error = "Not logged in";
        isLoading = false;
      });
      return false;
    }

    bool successfulReq = true;
    var url = HttpManager.getVerifyAmountEndpoint();

    var response = await http.get(url, headers: {
      "Accesstoken": accessToken,
      "Amount": amount.toStringAsExponential(3),
    }).catchError((error) {
      successfulReq = false;
    });
    if (!successfulReq) {
      setState(() {
        isError = true;
        error = "Unable to contact servers";
        isLoading = false;
      });
      return false;
    }
    final body = jsonDecode(response.body);

    if (body["message"] == "successful") {
      return true;
    } else {
      setState(() {
        isError = true;
        error = body["message"];
        isLoading = false;
      });
    }
    return false;
  }
}

Widget buildTextField(IconData icon, String hintText, bool isPassword,
    bool isEmail, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 70),
    child: TextField(
      obscureText: isPassword,
      controller: controller,
      keyboardType: TextInputType.number,
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
