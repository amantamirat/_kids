import 'package:abdu_kids/util/preference_util.dart';
import 'package:flutter/material.dart';

class Constants {
  
  static const String appName = "abdu_kids";

  static const String newPath = "/new";

  static const String updatePath = "/update";

  static const String deletePath = "/delete";

  static const String editMode = "editMode";

  static const String manageMode = "manageMode";

  static const Map<String, String> requestHeaders = {
    'Content-Type': 'application/json',
  };

  static const String noImageAssetPath =
      "assets/images/No-Image-Placeholder.svg.png";

  static Image noImagePlaceHolder = Image.asset(noImageAssetPath);

  static String getImageURL(id) {
    return "${Constants.imageFileURL}/$id";
  }

  static String apiURL = "${protocol()}://${hostName()}:${portNumber()}";
  static String imageFileURL = "$apiURL/files";

  static String protocol() {
    return SharedPrefs.instance.getString(SharedPrefs.keyProtocol) ?? 'http';
  }

  static String hostName() {
    return SharedPrefs.instance.getString(SharedPrefs.keyHostAddress) ??
        'localhost';
  }

  static int portNumber() {
    return SharedPrefs.instance.getInt(SharedPrefs.keyPortNumber) ?? 8080;
  }

  /*
  static int defaultMOQ() {
    return SharedPrefs.instance.getInt(SharedPrefs.keyMOQ) ?? 4;
  }*/
}
