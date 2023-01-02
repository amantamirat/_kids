import 'package:http/http.dart' as http;
import '../util/constants.dart';

class ImageService {
  static var client = http.Client();
  static Future<bool> uploadImage(String id, String imagePath) async {
    var request = http.MultipartRequest(
        "PUT", Uri.parse("${Constants.apiURL}/upload/$id"));
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
      "image",
      imagePath,
    );
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  static Future<bool> deleteImage(String id) async {
    String url = "${Constants.apiURL}/upload/remove/$id";
    var response = await client.delete(
      Uri.parse(url),
      headers: Constants.requestHeaders,
    );
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }
}
