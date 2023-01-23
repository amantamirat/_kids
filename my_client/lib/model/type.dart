import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/my_model.dart';

class ClothingType extends MyModel {
  
  static const String path = "/types";
  static const String attributeType = 'type';
  static const String attributeBrands = 'brands';
  
  late String? type;
  late Category? category;
  late List<Brand> brands = List.empty(growable: true);
  
  ClothingType({this.category});

  @override
  ClothingType fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    type = json[attributeType];
    brands = Brand.brandsFromJson(json[attributeBrands], this);
    return this;
  }

  @override
  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data["_id"] = id;
    }
    data[attributeType] = type;
    return data;
  }

  @override
  String basePath() {
    return path;
  }

  @override
  String paramsPath() {
    return "/${category!.id}";
  }

  @override
  String toString() {
    return type!;
  }

  static List<ClothingType> clothingTypesFromJson(dynamic str, Category category) =>
      List<ClothingType>.from((str).map((x) => ClothingType(category: category).fromJson(x)));
}
