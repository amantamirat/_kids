import 'package:abdu_kids/model/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../util/config.dart';

class CategoryService {
  
  static var client = http.Client();

  static Future<List<Category>?> getCategories() async {
    var url = Uri.http(
      Config.apiURL,
      Category.pathURL,
    );
    var response = await client.get(
      url,
      headers: Config.requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return categoriesFromJson(data["categories"]);
    } else {
      return null;
    }
  }

  static Future<http.StreamedResponse> uploadImage(
      String id, String imagePath) async {
    var request = http.MultipartRequest(
        "PUT", Uri.http("http://${Config.apiURL}/upload/$id"));
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
      "image",
      imagePath,
    );
    request.files.add(multipartFile);
    return request.send();
  }

  static Future<bool> saveCategory(
      Category category, bool isEditMode, String? selectedImagePath) async {
    String url = "http://${Config.apiURL}${Category.pathURL}";
    var response = http.Response("{}", 400);
    if (isEditMode) {
      url = "$url/update/${category.id}";
      response = await http.patch(
        Uri.parse(url),
        headers: Config.requestHeaders,
        body: jsonEncode(category.toJson()),
      );
    } else {
      url = "$url/new";
      response = await http.post(
        Uri.parse(url),
        headers: Config.requestHeaders,
        body: jsonEncode(category.toJson()),
      );
    }
    if (response.statusCode != 201) {
      return false;
    }
    if (selectedImagePath != null) {
      uploadImage(category.id!, selectedImagePath);
    }
    return true;
  }
}
