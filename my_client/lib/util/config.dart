import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Config {
  static const String appName = "abdu_kids";
  static const String apiURL = "10.194.49.20:8080";
  //static const String apiURL = "192.168.1.20:8080";
  static const String catagoryURL = "/categories";

  static Image NoImagePlaceHolder = Image.asset(
    "assets/images/No-Image-Placeholder.svg.png",
    width: 200,
    height: 200,
  );
}
