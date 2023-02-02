import 'package:abdu_kids/services/preference_util.dart';

class Constants {
  static const String appName = "abdu_kids";

  static const String newPath = "/new";

  static const String updatePath = "/update";

  static const String deletePath = "/delete";

  static const String loggedInUser = "loggedInUser";

  static const Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
  };

  static Map<String, String> prepareHeaders(String token) => {
        'x-access-token': token,
        'Content-Type': 'application/json',
      };

  static const String noImageAssetPath =
      "assets/images/No-Image-Placeholder.svg.png";

  static String getImageURL(id) => "${SharedPrefs.hostURL()}/files/$id";

  static String apiURL() => SharedPrefs.hostURL();
}
