import 'package:abdu_kids/util/config.dart';
import 'package:flutter/material.dart';

List<Category> categoriesFromJson(dynamic str) =>
    List<Category>.from((str).map((x) => Category.fromJson(x)));

class Category {
  late String? id;
  late String? title;
  late String? description;
  late String? imageURL;
  late Image categoryImage;

  Category({this.title, this.description, this.imageURL});

  Category.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    title = json["title"];
    description = json["description"];
    imageURL = json["cat_image_url"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["_id"] = id;
    data["title"] = title;
    data["description"] = description;
    data["cat_image_url"] = imageURL;
    return data;
  }

  String getFullImageURL() {
    return 'http://${Config.apiURL}/files$imageURL';
  }
}
