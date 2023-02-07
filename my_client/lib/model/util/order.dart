import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/util/ordered_item.dart';

class Order extends MyModel {
  static const String attributeDate = "order_date";
  static const String attributeTotalQuantity = "total_quantity";
  static const String attributeTotalPrice = "total_price";
  static const String attributeItems = "items";

  String? date;
  num? totalQuantity;
  num? totalPrice;
  List<OrderedItem>? orderedItems;

  Order({
    this.date,
    this.totalQuantity,
    this.totalPrice,
  });
  @override
  Map<String, dynamic> toJson({bool includeId = true}) {
    return {
      attributeDate: date,
      attributeTotalQuantity: totalQuantity,
      attributeTotalPrice: totalPrice
    };
  }

  @override
  Order fromJson(Map<String, dynamic> json) {
    id = json[MyModel.attributeId];
    date = json[attributeDate];
    totalQuantity = json[attributeTotalQuantity];
    totalPrice = json[attributeTotalPrice];
    orderedItems = json[attributeItems];
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

  static List<Order> ordersFromJson(dynamic str) =>
      List<Order>.from((str).map((x) => Order().fromJson(x)));
}