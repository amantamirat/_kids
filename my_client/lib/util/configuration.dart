import 'package:abdu_kids/util/preference_util.dart';

class Configuration {
  static const String appName = "abdu_kids";

  static const Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
  };

  static String getImageURL(id) {
    return "${Configuration.imageFileURL}/$id";
  }

  static String apiURL = "${protocol()}://${hostName()}:${portNumber()}";
  static String imageFileURL = "$apiURL/files";

  static String protocol() {
    return SharedPrefs.instance.getString(SharedPrefs.keyProtocol) ?? 'http';
  }

  static String hostName() {
    return SharedPrefs.instance.getString(SharedPrefs.keyHostAddress) ??
        'localhost';
  }

  static int portNumber() {
    return SharedPrefs.instance.getInt(SharedPrefs.keyPortNumber) ?? 8080;
  }
}
