class Endpoints {
  static String host = "127.0.0.1";
  static String port = "8080";
  static Function uriFunc = Uri.http;

  static Uri getCreateAccountEndpoint(){
    return uriFunc("$host:$port/create_account");
  }
  static Uri getLogInEndpoint(){
    return uriFunc("$host:$port/login");
  }
}