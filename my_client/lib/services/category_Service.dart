import 'package:abdu_kids/model/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/config.dart';

class CategoryService {
  static var client = http.Client();

  static Future<List<Category>?> getCategories() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url = Uri.http(
      Config.apiURL,
      Config.catagoryURL,
    );

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return categoriesFromJson(data["categories"]);
    } else {
      return null;
    }
  }

  
}
