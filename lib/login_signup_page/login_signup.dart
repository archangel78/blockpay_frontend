import 'dart:convert';
import 'package:blockpay_frontend/account_page/account_page.dart';
import 'package:blockpay_frontend/home_page/block_pay_home.dart';
import 'package:blockpay_frontend/login_signup_page/complete_signup.dart';
import 'package:blockpay_frontend/main.dart';
import 'package:blockpay_frontend/config/http_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:blockpay_frontend/model/signinColorPallete.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;
  bool isLoginError = false;
  bool isSignUpError = false;
  bool isSignUpLoading = false;
  String loginError = "Some error occurred while logging in";
  String signUpError = "Some error occurred while Signing up";

  final unameSUpController = TextEditingController();
  final emailSUpController = TextEditingController();
  final passwordSUController = TextEditingController();

  final idSiController = TextEditingController();
  final passwordSIController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 500,
              decoration: BoxDecoration(color: Color.fromARGB(255, 0, 14, 59)),
              child: Container(
                padding: EdgeInsets.only(top: 50),
                alignment: Alignment.center,
                color: Color.fromARGB(255, 8, 33, 87).withOpacity(.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 150,
                      child: Image.asset(
                        "assets/images/blockpaylogo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Welcome",
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 2,
                            color: Colors.yellow[700],
                          ),
                          children: [
                            TextSpan(
                              text: isSignupScreen ? " to Blockpay," : " Back,",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[700],
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      isSignupScreen
                          ? "Signup to Continue"
                          : "Signin to Continue",
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Trick to add the shadow for the submit button
          buildBottomHalfContainer(true, context),
          //Main Contianer for Login and Signup
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: isSignupScreen ? 265 : 300,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              height: isSignupScreen ? 340 : 270,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1),
                              ),
                              if (!isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Colors.orange,
                                )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "SIGNUP",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1),
                              ),
                              if (isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Colors.orange,
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                    if (isSignupScreen) buildSignupSection(),
                    if (!isSignupScreen) buildSigninSection()
                  ],
                ),
              ),
            ),
          ),
          // Trick to add the submit button
          buildBottomHalfContainer(false, context),
        ],
      ),
    );
  }

  Container buildSigninSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(Icons.mail_outline, "Email or username", false, true,
              idSiController),
          buildTextField(MaterialCommunityIcons.lock_outline, "**********",
              true, false, passwordSIController),
          (isLoginError)
              ? Container(
                  child: Text(
                    loginError,
                    style: TextStyle(color: Colors.red),
                  ),
                  alignment: Alignment.topLeft,
                )
              : SizedBox(
                  height: 0,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isRememberMe,
                    activeColor: Palette.textColor2,
                    onChanged: (value) {
                      setState(() {
                        isRememberMe = !isRememberMe;
                      });
                    },
                  ),
                  Text("Remember me",
                      style: TextStyle(fontSize: 12, color: Palette.textColor1))
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text("Forgot Password?",
                    style: TextStyle(fontSize: 12, color: Palette.textColor1)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          (isSignUpLoading)
              ? Container(
                  height: 80,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator())
              : SizedBox(),
          Column(
            children: [
              buildTextField(MaterialCommunityIcons.account_outline,
                  "User Name", false, false, unameSUpController),
              buildTextField(MaterialCommunityIcons.email_outline, "email",
                  false, true, emailSUpController),
              buildTextField(MaterialCommunityIcons.lock_outline, "password",
                  true, false, passwordSUController),
              (isSignUpError)
                  ? Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        signUpError,
                        style: TextStyle(color: Colors.red),
                      ),
                      alignment: Alignment.topLeft,
                    )
                  : SizedBox(
                      height: 0,
                    ),
              Container(
                width: 200,
                margin: EdgeInsets.only(top: 15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "By pressing 'Submit' you agree to our ",
                      style: TextStyle(color: Palette.textColor2),
                      children: [
                        TextSpan(
                          //recognizer: ,
                          text: "terms & conditions",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          side: BorderSide(width: 1, color: Colors.grey),
          minimumSize: Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow, BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 575 : 535,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                  )
              ]),
          child: !showShadow
              ? GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 18, 6, 92),
                              Color.fromARGB(255, 26, 13, 112),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1))
                        ]),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () async {
                    if (isSignupScreen) {
                      String username = unameSUpController.text;
                      String email = emailSUpController.text;
                      String password = passwordSUController.text;

                      if (!verifySignUpLength("Username", username, 4) ||
                          !verifySignUpLength("Email", email, 8) ||
                          !verifySignUpLength("Password", password, 5)) {
                        return;
                      }

                      setState(() {
                        isSignUpLoading = true;
                      });
                      var successfulPV =
                          await PreVerifyAccount(username, email, password);
                      setState(() {
                        isSignUpLoading = false;
                      });

                      if (successfulPV) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompleteSignUp(
                                      username: unameSUpController.text,
                                      emailId: emailSUpController.text,
                                      password: passwordSUController.text,
                                    )),
                            ModalRoute.withName("/"));
                      }
                    } else {
                      String id = idSiController.text;
                      String password = passwordSIController.text;

                      if (!verifyLogInLength("Username or Email", id, 4) ||
                          !verifyLogInLength("Password", password, 5)) {
                        return;
                      }
                      var successfulLogin = await logIn(id, password);
                      if (successfulLogin) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlockPayHome()),
                        );
                      } else {
                        setState(() {
                          isLoginError = true;
                        });
                      }
                    }
                  },
                )
              : Center(),
        ),
      ),
    );
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

  Future<bool> PreVerifyAccount(
      String username, String email, String password) async {
    var url = HttpManager.getPreVerifyEndpoint();
    bool successfulReq = true;

    var response = await http.post(url, headers: {
      "Accountname": username,
      "Emailid": email,
      "password": password,
    }).catchError((error) {
      successfulReq = false;
    });
    if (!successfulReq) {
      return false;
    }
    final body = jsonDecode(response.body);
    if (body["message"] != "successful") {
      setState(() {
        isSignUpError = true;
        signUpError = body["message"];
      });
      return false;
    }
    return true;
  }

  Future<bool> logIn(String id, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceToken = prefs.getString("notDeviceToken") ?? "None";
    print(deviceToken);
    
    var url = HttpManager.getLogInEndpoint();
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(id);
    String idName = "";
    if (emailValid) {
      idName = "Emailid";
    } else {
      idName = "Accountname";
    }
    bool successfulReq = true;
    var response = await http.post(url, headers: {
      idName: id,
      "password": password,
      "deviceToken": deviceToken
    }).catchError((error) {
      successfulReq = false;
    });
    if (!successfulReq) {
      return false;
    }
    final body = jsonDecode(response.body);
    if (body["message"] == "successful") {
      await prefs.setString("accessToken", body["accessToken"]);
      await prefs.setString("refreshToken", body["refreshToken"]);
      await prefs.setString("walletPrivId", body["walletPrivId"]);
      await prefs.setString("accountName", body["accountName"]);
      await prefs.setString("walletPubKey", body["walletPubKey"]);
      return true;
    } else if (body["message"] == "Unauthorized") {
      loginError = "Invalid Credentials";
      return false;
    } else {
      loginError = body["message"];
      return false;
    }
  }

  bool verifySignUpLength(String fieldName, String value, int requiredLength) {
    if (value.length < requiredLength) {
      setState(() {
        isSignUpError = true;
        signUpError =
            "$fieldName should be longer than $requiredLength characters";
      });
      return false;
    }
    return true;
  }

  bool verifyLogInLength(String fieldName, String value, int requiredLength) {
    if (value.length < requiredLength) {
      setState(() {
        isLoginError = true;
        loginError =
            "$fieldName should be longer than $requiredLength characters";
      });
      return false;
    }
    return true;
  }
}
