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

  static Future<bool> saveCategory(
      Category category, bool isEditMode, bool isFileSelected) async {
    var categoryURL = Config.catagoryURL;
    var requestMethod = "POST";
    if (isEditMode) {
      categoryURL = categoryURL + "/update/" + category.id.toString();
      requestMethod = "PUT";
    } else {
      categoryURL = categoryURL + "/new";
    }
    var url = Uri.http(Config.apiURL, categoryURL);
    var request = http.MultipartRequest(requestMethod, url);
    request.fields[Category.attributeTitle] = category.title!;
    request.fields[Category.attributeDescription] = category.description!;

    if (category.imageURL != null && isFileSelected) {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'images',
        category.imageURL!,
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
