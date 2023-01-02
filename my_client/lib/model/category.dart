import 'package:abdu_kids/model/type.dart';

class Category {
  static const String path = "/categories";
  static const String attributeTitle = 'title';
  static const String attributeDescription = 'description';
  static const String attributeClothingTypes = 'clothing_types';

  late String? id;
  late String? title;
  late String? description;

  List<ClothingType> clothingTypes = List.empty();

  Category({this.title, this.description});

  Category.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    title = json[attributeTitle];
    description = json[attributeDescription];
    clothingTypes =  ClothingType.clothingTypesFromJson(json[attributeClothingTypes]);
  }

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

  static List<Category> categoriesFromJson(dynamic str) =>
    List<Category>.from((str).map((x) => Category.fromJson(x)));
}
