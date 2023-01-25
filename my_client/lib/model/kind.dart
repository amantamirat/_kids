import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';

class Kind extends MyModel {
  static const String path = "/kinds";
  static const String attributeColor = 'color';
  static const String attributeQuantity = 'quantity';
  //static const String attributeProduct = 'product';

  late String? color;
  late int? quantity;

  late Product? product;
  Kind({this.product});

  @override
  Kind fromJson(Map<String, dynamic> json) {
    id = json[MyModel.attributeId];
    color = json[attributeColor];
    quantity = json[attributeQuantity];
    /*
    if (includeLocal) {
      product = Product().fromJson(json[attributeProduct]);
    }
    */

    return this;
  }

  @override
  Map<String, dynamic> toJson(
      {bool includeId = true, bool includeLocal = false}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data[MyModel.attributeId] = id;
    }
    data[attributeColor] = color;
    data[attributeQuantity] = quantity;
    /*
    if (includeLocal) {
      data[attributeProduct] =
          jsonEncode(product!.toJson(includeLocal: includeLocal));
    }
    */
    return data;
  }

  @override
  String header() {
    return "${product!.brand!.name} - ${product!.detail} - ${product!.size}";
  }

  @override
  String basePath() {
    return path;
  }

  @override
  String paramsPath() {
    return "${product!.paramsPath()}/${product!.id}";
  }

  @override
  String toString() {
    return "${product!.detail} $color";
  }

  static List<Kind> kindsFromJson(dynamic str, Product product) =>
      List<Kind>.from((str).map((x) => Kind(product: product).fromJson(x)));
}
