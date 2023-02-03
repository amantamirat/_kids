import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/util/page_names.dart';

class Product extends MyModel {
  //static const String path = "/products";
  static const String attributeDetail = 'product_detail';
  static const String attributeSize = 'size';
  static const String attributePrice = 'price';
  static const String attributeMOQ = 'minimum_order_quanity';
  static const String attributeKinds = 'product_kinds';
  //static const String attributeBrand = 'brand';

  late String? detail;
  late num size;
  late num price;
  late num moq;

  late Brand? brand;
  late List<Kind> kinds = List.empty(growable: true);

  Product({this.brand});

  @override
  Product fromJson(Map<String, dynamic> json) {
    id = json[MyModel.attributeId];
    detail = json[attributeDetail];
    size = json[attributeSize];
    price = json[attributePrice];
    moq = json[attributeMOQ] ?? 0;
    //if (json.containsKey(attributeKinds)) {
    kinds = Kind.kindsFromJson(json[attributeKinds], this);
    //}
    return this;
  }

  @override
  Map<String, dynamic> toJson(
      {bool includeId = true, bool includeLocal = false}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data[MyModel.attributeId] = id;
    }
    data[attributeDetail] = detail;
    data[attributeSize] = size;
    data[attributePrice] = price;
    data[attributeMOQ] = moq;
    /*
    if (includeLocal) {
      data[attributeBrand] =
          jsonEncode(brand!.toJson(includeLocal: includeLocal));
    }
    */
    return data;
  }

  @override
  String basePath() {
    return "/${PageNames.products}";
  }

  @override
  String paramsPath() {
    return "${brand!.paramsPath()}/${brand!.id}";
  }

  @override
  String header() {
    return "${brand!.name}/$detail/$size";
  }

  @override
  String toString() {
    return detail!;
  }

  static List<Product> productsFromJson(dynamic str, Brand brand) =>
      List<Product>.from((str).map((x) => Product(brand: brand).fromJson(x)));
}
