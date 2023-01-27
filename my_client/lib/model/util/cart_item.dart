import 'package:abdu_kids/model/kind.dart';

class CartItem {
  static const String tableName = "cart_items";
  static const String attributeId = "id";
  //static const String attributeKind = "kind";
  static const String attributeQuantity = "quantity";

  final String id;
  late int quantity;
  final Kind? selectedKind;

  CartItem({
    required this.id,
    required this.quantity,
    this.selectedKind,
  });

  Map<String, dynamic> toMap() {
    return {
      attributeId: id,
      //attributeKind: jsonEncode(selectedKind.toJson(includeLocal: true)),
      attributeQuantity: quantity,
    };
  }

  @override
  String toString() {
    return 'Cart Item{id: $id, kind : $selectedKind, quantity: $quantity}';
  }
}
