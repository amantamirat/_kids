import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/my_model.dart';

class Product extends MyModel<Product> {
  static const String path = "/products";
  //static const String attributeProductName = 'product_name';
  //static const String attributeDescription = 'product_description';
  static const String attributeSize = 'size';
  static const String attributePrice = 'price';
  static const String attributeKinds = 'product_kinds';

  //late String? name;
  //late String? description;
  late num size;
  late num price;

  late Brand? brand;
  late List<Kind> kinds;

  Product({this.brand});

  @override
  Product fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    //name = json[attributeProductName];
    //description = json[attributeDescription];
    size = json[attributeSize];
    price = json[attributePrice];
    kinds = Kind.kindsFromJson(json[attributeKinds], this);
    return this;
  }

  @override
  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data["_id"] = id;
    }
    //data[attributeProductName] = name;
    //data[attributeDescription] = description;
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
    return "${brand!.paramsPath()}/${brand!.id}";
  }

  static List<Product> productsFromJson(dynamic str, Brand brand) =>
      List<Product>.from((str).map((x) => Product(brand: brand).fromJson(x)));
}
