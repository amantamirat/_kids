import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const keyHostAddress = "hostAddress";

  static late final SharedPreferences instance;

  static late final SessionManager sessionManager;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  static String hostURL() =>
      instance.getString(keyHostAddress) ?? 'http://localhost:8080';

/*
  static Future<SessionManager> initSession() async =>
      sessionManager = SessionManager();

  static User loggedInUser() {
    dynamic data = sessionManager.get(Constants.loggedInUser);
    return User().fromJson(data);
  }
  */
}
