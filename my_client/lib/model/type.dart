import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';

class ClothingType extends MyModel<ClothingType> {
  
  static const String path = "/types";
  static const String attributeType = 'type';
  static const String attributeProducts = 'products';
  
  late String? type;
  late Category? category;
  late List<Product> products;
  
  ClothingType({this.category});

  @override
  ClothingType fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    type = json[attributeType];
    products = Product.productsFromJson(json[attributeProducts]);
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

  static List<ClothingType> clothingTypesFromJson(dynamic str, Category category) =>
      List<ClothingType>.from((str).map((x) => ClothingType(category: category).fromJson(x)));
}
