import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/services/image_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../util/constants.dart';

class MyService {
  static var client = http.Client();

  static Future<List<Category>?> getCategories() async {
    String url = "${Constants.apiURL}/categories";
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
    String url = "${Constants.apiURL}${myModel.path()}";
    var response = http.Response("{}", 404);
    if (isEditMode) {
      url = "$url/update/${myModel.id}";
      response = await http.patch(
        Uri.parse(url),
        headers: Constants.requestHeaders,
        body: jsonEncode(myModel.toJson()),
      );
    } else {
      url = "$url/new";
      response = await http.post(
        Uri.parse(url),
        headers: Constants.requestHeaders,
        body: jsonEncode(myModel.toJson(includeId: false)),
      );
    }
    if (response.statusCode != 201) {
      return false;
    }
    return true;
  }

  static Future<bool> deleteModel(MyModel myModel) async {
    String url = "${Constants.apiURL}${myModel.path}/delete/${myModel.id}";
    var response = await client.delete(
      Uri.parse(url),
      headers: Constants.requestHeaders,
    );
    if (response.statusCode == 204) {
      return ImageService.deleteImage(myModel.id!);
    } else {
      return false;
    }
  }
}
