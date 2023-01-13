import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/my_model.dart';

class Product extends MyModel<Product> {
  static const String path = "/products";
  //static const String attributeProductName = 'product_name';
  static const String attributeDetail = 'product_detail';
  static const String attributeSize = 'size';
  static const String attributePrice = 'price';
  static const String attributeKinds = 'product_kinds';

  //late String? name;
  late String? detail;
  late num size;
  late num price;

  late Brand? brand;
  late List<Kind> kinds = List.empty(growable: true);

  Product({this.brand});

  @override
  Product fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    //name = json[attributeProductName];
    detail = json[attributeDetail];
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
    data[attributeDetail] = detail;
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

  final List<Kind> _avialiableKinds = List.empty(growable: true);

  List<Kind> avialiableKinds() {
    for (Kind k in kinds) {
      if (k.quantity! > 0) {
        if (!_avialiableKinds.contains(k)) {
          _avialiableKinds.add(k);
        }
      } else {
        if (_avialiableKinds.contains(k)) {
          _avialiableKinds.remove(k);
        }
      }
    }
    return _avialiableKinds;
  }

  static List<Product> productsFromJson(dynamic str, Brand brand) =>
      List<Product>.from((str).map((x) => Product(brand: brand).fromJson(x)));
}
