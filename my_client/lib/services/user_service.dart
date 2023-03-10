import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/model/util/cart_item.dart';
import 'package:abdu_kids/model/util/order.dart';
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
      return User.usersFromJson(data["data"]);
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
    user.id = data["data"]["_id"];
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
    user.id = data["data"]["_id"];
    var userstatus = data["data"][User.attributeUserStatus];
    for (Status s in Status.values) {
      if (userstatus == s.title) {
        user.status = s;
        break;
      }
    }
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

  static Future<String> placeOrders(User user, List<CartItem> items) async {
    num totalPrice = 0;
    num totalquantity = 0;
    for (int i = 0; i < items.length; i++) {
      final item = items.elementAt(i);
      totalquantity = totalquantity + item.quantity;
      totalPrice =
          totalPrice + item.quantity * item.selectedKind!.product!.price;
    }
    var orderItems = CartItem.jsonFromItemList(items);
    String url =
        "${Constants.apiURL()}/${PageNames.users}/placeOrders/${user.id}";

    
    var response = await client.post(
      Uri.parse(url),
      headers: Constants.prepareHeaders(user.token!),
      body: jsonEncode({
        'total_quantity': totalquantity,
        'total_price': totalPrice,
        'items': orderItems
      }),
    );
    
    var data = jsonDecode(response.body);
    //user.message = data["message"];
    return "${data['message']}";
  }

  static Future<List<Order>?> findOrders(User selectedUser) async {
    String url =
        "${Constants.apiURL()}/${PageNames.users}/findOrders/${selectedUser.id}";
    var response = await client.get(
      Uri.parse(url),
      headers: Constants.prepareHeaders(selectedUser.token!),
    );
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      //print(data["data"].toString());
      return Order.ordersFromJson(data["data"]);
    } else {
      return null;
    }
  }
}
