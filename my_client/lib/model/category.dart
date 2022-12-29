import 'package:abdu_kids/util/config.dart';

List<Category> categoriesFromJson(dynamic str) =>
    List<Category>.from((str).map((x) => Category.fromJson(x)));

class Category {
  static const String pathURL = "/categories";
  static const String attributeTitle = 'title';
  static const String attributeDescription = 'description';

  late String? id;
  late String? title;
  late String? description;

  Category({this.title, this.description});

  Category.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    title = json[attributeTitle];
    description = json[attributeDescription];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["_id"] = id!;
    data[attributeTitle] = title;
    data[attributeDescription] = description;
    return data;
  }
  /* 
  Map<String, dynamic> initJson() {
    final data = <String, dynamic>{};
    data[attributeTitle] = title;
    data[attributeDescription] = description;
    return data;
  }
  */

  String getImageURL() {
    return "${Config.imageFileURL}/$id";
  }
}
