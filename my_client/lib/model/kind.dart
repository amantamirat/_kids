import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/util/page_names.dart';

class Kind extends MyModel {
  //static const String path = "/kinds";
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
    return data;
  }

  @override
  String header() {
    return "${product!.detail}/${product!.size}/$color";
  }

  @override
  String basePath() {
    return "/${PageNames.kinds}";
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
