import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/type.dart';

class Product extends MyModel<Product> {
  static const String path = "/products";
  static const String attributeProductName = 'product_name';
  static const String attributeDescription = 'product_description';
  static const String attributeSize = 'size';
  static const String attributePrice = 'price';

  late String? name;
  late String? description;
  late int? size;
  late num price;

  late ClothingType? type;

  Product({this.type});

  //Product({this.name, this.description, this.size, this.price});

  @override
  Product fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json[attributeProductName];
    description = json[attributeDescription];
    size = json[attributeSize];
    price = json[attributePrice];
    return this;
  }

  @override
  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data["_id"] = id;
    }
    data[attributeProductName] = name;
    data[attributeDescription] = description;
    data[attributeSize] = size;
    data[attributePrice] = price;
    return data;
  }

  @override
  String basePath() {
    return path;
  }

  @override
  String paramsPath() {
    return "/${type!.category!.id}/${type!.id}";
  }

  static List<Product> productsFromJson(dynamic str) =>
      List<Product>.from((str).map((x) => Product().fromJson(x)));
}
