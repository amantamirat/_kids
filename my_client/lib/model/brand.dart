import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/model/type.dart';

class Brand extends MyModel<Brand> {
  static const String path = "/brands";
  static const String attributeName = 'brand_name';
  static const String attributeProducts = 'products';
  late String? name;
  late ClothingType? type;
  late List<Product> products = List.empty(growable: true);

  Brand({this.type});

  @override
  Brand fromJson(Map<String, dynamic> json) {
    id = json[MyModel.attributeId];
    name = json[attributeName];
    products = Product.productsFromJson(json[attributeProducts], this);
    return this;
  }

  @override
  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data["_id"] = id;
    }
    data[attributeName] = name;
    return data;
  }

  @override
  String basePath() {
    return path;
  }

  @override
  String paramsPath() {
    return "${type!.paramsPath()}/${type!.id}";
  }

  static List<Brand> brandsFromJson(dynamic str, ClothingType type) =>
      List<Brand>.from((str).map((x) => Brand(type: type).fromJson(x)));
}
