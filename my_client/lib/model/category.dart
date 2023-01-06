import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/type.dart';

class Category extends MyModel<Category> {
  static const String path = "/categories";
  static const String attributeTitle = 'title';
  static const String attributeDescription = 'description';
  static const String attributeClothingTypes = 'clothing_types';
  late String? title;
  late String? description;

  List<ClothingType> clothingTypes = List.empty();

  Category({this.title, this.description});

  @override
  Category fromJson(Map<String, dynamic> json) {
    id = json[MyModel.attributeId];
    title = json[attributeTitle];
    description = json[attributeDescription];
    clothingTypes =
        ClothingType.clothingTypesFromJson(json[attributeClothingTypes], this);
    return this;
  }

  @override
  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data["_id"] = id;
    }
    data[attributeTitle] = title;
    data[attributeDescription] = description;
    //data[attributeClothingTypes] = clothingTypes;
    return data;
  }

  @override
  String basePath() {
    return path;
  }

  @override
  String paramsPath() {
    return "";
  }

  static List<Category> categoriesFromJson(dynamic str) =>
      List<Category>.from((str).map((x) => Category().fromJson(x)));
}
