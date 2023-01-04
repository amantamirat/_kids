import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../util/constants.dart';

class MyService {
  static var client = http.Client();

  static Future<List<Category>?> getCategories() async {
    String url = "${Constants.apiURL}${Category.path}";
    var response = await client.get(
      Uri.parse(url),
      headers: Constants.requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Category.categoriesFromJson(data["categories"]);
    } else {
      return null;
    }
  }

  static Future<bool> saveItem(MyModel myModel, bool isEditMode) async {
    String url = "${Constants.apiURL}${myModel.basePath()}";
    var response = http.Response("{}", 404);
    if (isEditMode) {
      url = "$url${Constants.updatePath}${myModel.paramsPath()}/${myModel.id}";
      response = await http.patch(
        Uri.parse(url),
        headers: Constants.requestHeaders,
        body: jsonEncode(myModel.toJson()),
      );
    } else {
      url = "$url${Constants.newPath}${myModel.paramsPath()}";
      response = await http.post(
        Uri.parse(url),
        headers: Constants.requestHeaders,
        body: jsonEncode(myModel.toJson(includeId: false)),
      );
    }
    print(url);
    print(response.statusCode);
    if (response.statusCode != 201) {
      return false;
    }
    return true;
  }

  static Future<bool> deleteModel(MyModel myModel) async {
    String url =
        "${Constants.apiURL}${myModel.basePath()}${Constants.deletePath}${myModel.paramsPath()}/${myModel.id}";
    var response = await client.delete(
      Uri.parse(url),
      headers: Constants.requestHeaders,
    );
    print(url);
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
