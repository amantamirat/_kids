import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/constants.dart';

class UserService {
  static var client = http.Client();

  static Future<List<User>?> getUsers() async {
    String url = "${Constants.apiURL()}/${PageNames.users}";
    var response = await client.get(
      Uri.parse(url),
      headers: Constants.requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return User.usersFromJson(data[PageNames.users]);
      ;
    } else {
      return null;
    }
  }

  static Future<User?> logInUser(String email, String password) async {
    String url = "${Constants.apiURL()}/${PageNames.users}/${PageNames.login}";
    var response = await client.post(
      Uri.parse(url),
      headers: Constants.requestHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );
    var data = jsonDecode(response.body);
    if (response.statusCode != 201) {
      return null;
    }
    return User().fromJson(data["data"]);
  }

  static Future<bool> registerUser(User user) async {
    var response = await http.post(
      Uri.parse(
          "${Constants.apiURL()}${user.basePath()}/${PageNames.register}"),
      headers: Constants.requestHeaders,
      body: jsonEncode(user.toJson(includeId: false)),
    );

    var data = jsonDecode(response.body);
    if (response.statusCode != 201) {
      user.message = data["message"].toString();
      return false;
    }
    user = User().fromJson(data["data"]);
    return true;
  }

  static Future<String?> changePassword(String id, String currentPassword,
      String newPassword, String token) async {
    String url = "${Constants.apiURL()}/${PageNames.users}/changePassword/$id";
    var response = await client.post(
      Uri.parse(url),
      headers: Constants.prepareHeaders(token),
      body:
          jsonEncode({'password': currentPassword, 'newPassword': newPassword}),
    );
    var data = jsonDecode(response.body);
    if (response.statusCode != 201) {
      return data["message"];
    }
    return null;
  }

  static Future<bool> verifyAccount(User user) async {
    String url = "${Constants.apiURL()}/${PageNames.users}/verify";
    var response = await client.post(
      Uri.parse(url),
      headers: Constants.requestHeaders,
      body: jsonEncode(user.toJson()),
    );
    var data = jsonDecode(response.body);
    if (response.statusCode != 201) {
      user.message = data["message"];
      return false;
    }
    user = User().fromJson(data["data"]);
    return true;
  }

  static Future<bool> sendCode(User user) async {
    String url = "${Constants.apiURL()}/${PageNames.users}/sendCode";
    var response = await client.post(
      Uri.parse(url),
      headers: Constants.requestHeaders,
      body: jsonEncode(user.toJson()),
    );
    var data = jsonDecode(response.body);
    if (response.statusCode != 201) {
      user.message = data["message"];
      return false;
    }
    return true;
  }
}
