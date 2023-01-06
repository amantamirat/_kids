import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';

class Kind extends MyModel<Kind> {
  static const String path = "/kinds";
  static const String attributeColor = 'color';
  static const String attributeQuantity = 'quantity';

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
  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data[MyModel.attributeId] = id;
    }
    data[attributeColor] = color;
    data[attributeQuantity] = quantity;
    return data;
  }

  @override
  String basePath() {
    return path;
  }

  @override
  String paramsPath() {
    return "${product!.paramsPath()}/${product!.id}";
  }
  static List<Kind> kindsFromJson(dynamic str, Product product) =>
      List<Kind>.from((str).map((x) => Kind(product: product).fromJson(x)));
}
