import 'package:abdu_kids/model/product.dart';

class ClothingType {
  static const String path = "/types";
  static const String attributeType = 'type';
  static const String attributeProducts = 'products';

  late String? id;
  late String? type;
  late List<Product> products;

  ClothingType({this.type});

  ClothingType.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    type = json[attributeType];
    products = Product.productsFromJson(json[attributeProducts]);
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data["_id"] = id;
    }
    data[attributeType] = type;
    return data;
  }

  static List<ClothingType> clothingTypesFromJson(dynamic str) =>
      List<ClothingType>.from((str).map((x) => ClothingType.fromJson(x)));
}
