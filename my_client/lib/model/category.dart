import 'package:abdu_kids/util/config.dart';

List<Category> categoriesFromJson(dynamic str) =>
    List<Category>.from((str).map((x) => Category.fromJson(x)));

class Category {
  static const String attributeTitle = 'title';
  static const String attributeDescription = 'description';
  static const String attributeImageURL = 'image_url';

  late String? id;
  late String? title;
  late String? description;
  late String? imageURL;

  Category({this.title, this.description, this.imageURL});

  Category.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    title = json[attributeTitle];
    description = json[attributeDescription];
    imageURL = json[attributeImageURL];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["_id"] = id;
    data[attributeTitle] = title;
    data[attributeDescription] = description;
    data[attributeImageURL] = imageURL;
    return data;
  }

  String getFullImageURL() {
    return 'http://${Config.apiURL}/files$imageURL';
  }

  
}
