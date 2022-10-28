import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpManager {
  static String host = "192.168.1.100";
  static String port = "8080";

  static Uri getPreVerifyEndpoint() {
    return Uri.http("$host:$port", "/pre_signup_verify");
  }

  static Uri getCreateAccountEndpoint() {
    return Uri.http("$host:$port", "/create_account");
  }

  static Uri getLogInEndpoint() {
    return Uri.http("$host:$port", "/login");
  }

  static Uri getTestJwtEndpoint() {
    return Uri.http("$host:$port", "/test_jwt");
  }

  static Uri getRenewJwtEndpoint() {
    return Uri.http("$host:$port", "/renew_token");
  }

  static Uri getCheckAccountEndpoint() {
    return Uri.http("$host:$port", "/check_account");
  }

  static Uri getCheckPhoneEndpoint() {
    return Uri.http("$host:$port", "/check_phone");
  }

  static Uri getVerifyAmountEndpoint() {
    return Uri.http("$host:$port", "/verify_send_amount");
  }

  static Uri getCreateTransactionEndpoint() {
    return Uri.http("$host:$port", "/create_transaction");
  }

  static Uri getGetBalanceEndpoint() {
    return Uri.http("$host:$port", "/get_balance");
  }

  static Uri getTransactionHistoryEndpoint() {
    return Uri.http("$host:$port", "/get_transaction_history");
  }

  static Uri getContactsEndpoint() {
    return Uri.http("$host:$port", "/get_contacts");
  }

  static Uri getVerifyPhoneEndpoint() {
    return Uri.http("$host:$port", "/verify_phoneno");
  }

  static Future<bool> renewAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    String? refreshToken = prefs.getString("refreshToken");
    if (accessToken != null && refreshToken != null) {
      var url = HttpManager.getRenewJwtEndpoint();
      var response = await http.post(url, headers: {
        "Accesstoken": accessToken,
        "Refreshtoken": refreshToken,
      });
      var body = jsonDecode(response.body);
      if (body["message"] == "successful") {
        prefs.setString("accessToken", body["accessToken"]);
        return true;
      }
      return false;
    }
    return false;
  }

  static Future<String> checkAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    if (accessToken != null) {
      var url = HttpManager.getTestJwtEndpoint();
      var response = await http.get(url, headers: {
        "Accesstoken": accessToken,
      });
      final body = jsonDecode(response.body);
      if (body["valid"] == "true") {
        Duration remainingTime = JwtDecoder.getRemainingTime(accessToken);
        Duration timeToRenew = Duration(minutes: 3);
        if (remainingTime.compareTo(timeToRenew) < 0) {
          if (!await renewAccessToken()) {
            return "false";
          }
        }
        return "true";
      } else if (body["valid"] == "expired") {
        if (await renewAccessToken()) {
          return "true";
        }
      }
    }
    return "false";
  }
}
