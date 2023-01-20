import 'package:abdu_kids/util/preference_util.dart';

class Constants {
  static const String appName = "abdu_kids";

  static const String newPath = "/new";

  static const String updatePath = "/update";

  static const String deletePath = "/delete";

  static const Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
  };

  static const String noImageAssetPath =
      "assets/images/No-Image-Placeholder.svg.png";

  static String getImageURL(id) => "${SharedPrefs.apiURL()}/files/$id";

  static String apiURL() => SharedPrefs.apiURL();
}
