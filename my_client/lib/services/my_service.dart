import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../util/constants.dart';

class MyService {
  
  static var client = http.Client();

  static late List<Category>? _data;

  static Future<List<Category>?> getCategories() async {
    String url = "${Constants.apiURL()}/${PageName.categories}";
    var response = await client.get(
      Uri.parse(url),
      headers: Constants.requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _data = Category.categoriesFromJson(data[PageName.categories]);
      return _data;
    } else {
      return null;
    }
  }

  static Future<bool> saveItem(MyModel myModel, bool isEditMode) async {
    String url = "${Constants.apiURL()}${myModel.basePath()}";
    var response = http.Response("{}", 404);
    if (isEditMode) {
      url = "$url${Constants.updatePath}${myModel.paramsPath()}/${myModel.id}";
      response = await http.patch(
        Uri.parse(url),
        headers: Constants.requestHeaders,
        body: jsonEncode(myModel.toJson()),
      );
      return response.statusCode == 201;
    }
    url = "$url${Constants.newPath}${myModel.paramsPath()}";
    response = await http.post(
      Uri.parse(url),
      headers: Constants.requestHeaders,
      body: jsonEncode(myModel.toJson(includeId: false)),
    );
    if (response.statusCode != 201) {
      return false;
    }
    var data = jsonDecode(response.body);
    myModel.id = data["data"]["_id"];
    return true;
  }

  static Future<bool> deleteModel(MyModel myModel) async {
    String url =
        "${Constants.apiURL()}${myModel.basePath()}${Constants.deletePath}${myModel.paramsPath()}/${myModel.id}";
    var response = await client.delete(
      Uri.parse(url),
      headers: Constants.requestHeaders,
    );
    return response.statusCode == 204;
  }

  @Deprecated("Bad Implementation")
  static Kind? findKindById(String id) {
    for (Category category in _data!) {
      for (ClothingType type in category.clothingTypes) {
        for (Brand brand in type.brands) {
          for (Product product in brand.products) {
            for (Kind kind in product.kinds) {
              if (kind.id == id) {
                return kind;
              }
            }
          }
        }
      }
    }
    return null;
  }

  static Future<List<User>?> getUsers() async {
    String url = "${Constants.apiURL()}/${PageName.users}";
    var response = await client.get(
      Uri.parse(url),
      headers: Constants.requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return User.usersFromJson(data[PageName.users]);
      ;
    } else {
      return null;
    }
  }
}
