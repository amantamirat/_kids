import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const keyProtocol = "protocol";
  static const keyHostAddress = "hostname";
  static const keyPortNumber = "port";

  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  static String apiURL() => "${protocol()}://${hostName()}:${portNumber()}";

  static String protocol() => instance.getString(keyProtocol) ?? 'http';

  static String hostName() => instance.getString(keyHostAddress) ?? 'localhost';

  static int portNumber() => instance.getInt(keyPortNumber) ?? 8080;  
  
}
