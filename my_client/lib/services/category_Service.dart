import 'package:abdu_kids/model/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/configuration.dart';

class CategoryService {
  static var client = http.Client();

  static Future<List<Category>?> getCategories() async {
    String url = "${Configuration.apiURL}${Category.path}";
    var response = await client.get(
      Uri.parse(url),
      headers: Configuration.requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Category.categoriesFromJson(data["categories"]);
    } else {
      return null;
    }
  }

  static Future<http.StreamedResponse> uploadImage(
      String id, String imagePath) async {
    var request = http.MultipartRequest(
        "PUT", Uri.parse("${Configuration.apiURL}/upload/$id"));
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
      "image",
      imagePath,
    );
    request.files.add(multipartFile);
    return request.send();
  }

  static Future<bool> saveCategory(
      Category category, bool isEditMode, String? selectedImagePath) async {
    String url = "${Configuration.apiURL}${Category.path}";
    var response = http.Response("{}", 404);
    if (isEditMode) {
      url = "$url/update/${category.id}";
      response = await http.patch(
        Uri.parse(url),
        headers: Configuration.requestHeaders,
        body: jsonEncode(category.toJson()),
      );
    } else {
      url = "$url/new";
      response = await http.post(
        Uri.parse(url),
        headers: Configuration.requestHeaders,
        body: jsonEncode(category.toJson(includeId: false)),
      );
    }
    if (response.statusCode != 201) {
      return false;
    }
    if (selectedImagePath != null) {
      if (!isEditMode) {
        category = Category.fromJson(jsonDecode(response.body)["data"]);
      }
      uploadImage(category.id!, selectedImagePath);
    }
    return true;
  }

  static Future<bool> deleteCategory(categoryId) async {
    String url = "${Configuration.apiURL}${Category.path}/delete/$categoryId";
    var response = await client.delete(
      Uri.parse(url),
      headers: Configuration.requestHeaders,
    );
    if (response.statusCode == 204) {
      url = "${Configuration.apiURL}/upload/remove/$categoryId";
      client.delete(
        Uri.parse(url),
        headers: Configuration.requestHeaders,
      );
      return true;
    } else {
      return false;
    }
  }
}
