import 'package:abdu_kids/util/preference_util.dart';

class Configuration {
  static const String appName = "abdu_kids";
  static const String apiURL = "http://10.194.49.20:8080";
  static const Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
  };
  static String imageFileURL = "$apiURL/files";

  static final someString =
      SharedPrefs.instance.getString('hostname') ?? 'localhost';
}
