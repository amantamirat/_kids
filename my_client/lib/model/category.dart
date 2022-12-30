import 'package:abdu_kids/util/configuration.dart';

List<Category> categoriesFromJson(dynamic str) =>
    List<Category>.from((str).map((x) => Category.fromJson(x)));

class Category {
  static const String path = "/categories";
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

  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data["_id"] = id;
    }
    data[attributeTitle] = title;
    data[attributeDescription] = description;
    return data;
  }

  String getImageURL() {
    return "${Configuration.imageFileURL}/$id";
  }
}
