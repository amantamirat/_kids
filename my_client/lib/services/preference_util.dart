import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const keyHostAddress = "hostAddress";

  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  static String hostURL() =>
      instance.getString(keyHostAddress) ?? 'http://localhost:8080';
}
