class Config {
  static const String appName = "abdu_kids";
  //static const String apiURL = "http://10.194.49.20:8080";
  static const String apiURL = "http://192.168.1.20:8080";
  static const Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
  };
  static const String imageFileURL = "$apiURL/files";
}
