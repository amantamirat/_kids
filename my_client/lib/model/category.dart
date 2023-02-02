import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/util/page_names.dart';

class Category extends MyModel {
  //static const String path = "/categories";
  static const String attributeTitle = 'title';
  static const String attributeDescription = 'description';
  static const String attributeClothingTypes = 'clothing_types';
  late String? title;
  late String? description;

  List<ClothingType> clothingTypes = List.empty(growable: true);

  Category({this.title, this.description});

  @override
  Category fromJson(Map<String, dynamic> json) {
    id = json[MyModel.attributeId];
    title = json[attributeTitle];
    description = json[attributeDescription];
    //if (json.containsKey(attributeClothingTypes)) {
    clothingTypes =
        ClothingType.clothingTypesFromJson(json[attributeClothingTypes], this);
    //}
    return this;
  }

  @override
  Map<String, dynamic> toJson({
    bool includeId = true,
  }) {
    final data = <String, dynamic>{};
    if (includeId) {
      data[MyModel.attributeId] = id;
    }
    data[attributeTitle] = title;
    data[attributeDescription] = description;
    return data;
  }

  @override
  String header() {
    return title!;
  }

  @override
  String basePath() {
    return "/${PageNames.categories}";
  }

  @override
  String paramsPath() {
    return "";
  }

  @override
  String toString() {
    return title!;
  }

  static List<Category> categoriesFromJson(dynamic str) =>
      List<Category>.from((str).map((x) => Category().fromJson(x)));
}
