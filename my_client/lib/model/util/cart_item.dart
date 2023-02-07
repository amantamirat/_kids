import 'package:abdu_kids/model/kind.dart';

class CartItem {
  static const String tableName = "cart_items";
  static const String attributeId = "kind_id";
  static const String attributeProductId = "product_id";
  static const String attributeBrandId = "brand_id";
  static const String attributeTypeId = "type_id";
  static const String attributeCategoryId = "category_id";
  static const String attributeQuantity = "quantity";
  static const String attributePrice = "price";

  final String categoryId;
  final String typeId;
  final String brandId;
  final String productId;
  final String kindId;
  int quantity;
  num price;
  late Kind? selectedKind;

  CartItem({
    required this.categoryId,
    required this.typeId,
    required this.brandId,
    required this.productId,
    required this.kindId,
    required this.quantity,
    required this.price,
    this.selectedKind,
  });

  Map<String, dynamic> toJson() {
    return {
      attributeId: kindId,
      attributeProductId: productId,
      attributeBrandId: brandId,
      attributeTypeId: typeId,
      attributeCategoryId: categoryId,
      attributeQuantity: quantity,
      attributePrice: price,
    };
  }

  @override
  String toString() {
    return 'Cart Item{Kind_id: $kindId, quantity: $quantity, product_id: $productId}';
  }

  static List<dynamic> jsonFromItemList(List<CartItem> items) =>
      List<dynamic>.from((items).map((x) => x.toJson()));
}
