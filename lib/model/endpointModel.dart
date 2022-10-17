import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpManager {
  static String host = "192.168.1.100";
  static String port = "8080";

  static Uri getCreateAccountEndpoint() {
    return Uri.http("$host:$port", "/create_account");
  }

  static Uri getLogInEndpoint() {
    return Uri.http("$host:$port", "/login");
  }

  static Uri getTestJwtEndpoint() {
    return Uri.http("$host:$port", "/test_jwt");
  }

  static Future<bool> renewAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");

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
      final body = await jsonDecode(response.body);
      if (body["valid"] == "true") {
        return "true";
      } else if (body["valid"] == "expired") {
        bool success = await renewAccessToken();
      }
    }
    return "false";
  }
}
