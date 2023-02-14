import 'package:abdu_kids/model/my_model.dart';

class OrderedItem extends MyModel {
  //static const String tableName = "ordered_items";
  static const String attributeKindId = "kind_id";
  static const String attributeBrand = "brand";
  static const String attributeProduct = "product_detail";
  static const String attributeProductSize = "product_size";
  static const String attributeProductColor = "product_color";
  static const String attributeProductPrice = "price";
  static const String attributeQuantity = "quantity";

  String? kindId;
  String? brand;
  String? productDetail;
  num? productSize;
  String? productColor;
  num? productPrice;
  int? quantity;

  OrderedItem(
      {this.brand,
      this.productDetail,
      this.productSize,
      this.productColor,
      this.productPrice,
      this.quantity,
      this.kindId});

  @override
  Map<String, dynamic> toJson({bool includeId = true}) {
    return {
      attributeBrand: brand,
      attributeProduct: productDetail,
      attributeProductSize: productSize,
      attributeProductColor: productColor,
      attributeProductPrice: productPrice,
      attributeQuantity: quantity,
    };
  }

  @override
  OrderedItem fromJson(Map<String, dynamic> json) {
    id = json[MyModel.attributeId];
    brand = json[attributeBrand];
    productDetail = json[attributeProduct];
    productSize = json[attributeProductSize];
    productColor = json[attributeProductColor];
    productPrice = json[attributeProductPrice];
    quantity = json[attributeQuantity];
    kindId = json[attributeKindId];
    return this;
  }

  @override
  String basePath() {
    throw UnimplementedError();
  }

  @override
  String paramsPath() {
    throw UnimplementedError();
  }

  @override
  String header() {
    throw UnimplementedError();
  }

  @override
  String toString() {
    return 'Ordered Item{brand: $brand, product: $productDetail, quantity: $quantity}';
  }

  static List<OrderedItem> orderItemsFromJson(dynamic str) =>
      List<OrderedItem>.from((str).map((x) => OrderedItem().fromJson(x)));
}
