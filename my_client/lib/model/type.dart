import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/util/page_names.dart';

class ClothingType extends MyModel {
  //static const String path = "/types";
  static const String attributeType = 'type';
  static const String attributeBrands = 'brands';
  //static const String attributeCategory = 'category';

  late String? type;
  late Category? category;
  late List<Brand> brands = List.empty(growable: true);

  ClothingType({this.category});

  @override
  ClothingType fromJson(Map<String, dynamic> json) {
    id = json[MyModel.attributeId];
    type = json[attributeType];
    //if (json.containsKey(attributeBrands)) {
    brands = Brand.brandsFromJson(json[attributeBrands], this);
    _initProducts();
    //}
    return this;
  }

  @override
  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = <String, dynamic>{};
    if (includeId) {
      data[MyModel.attributeId] = id;
    }
    data[attributeType] = type;
    /*
    if (includeLocal) {
      data[attributeCategory] = jsonEncode(category!.toJson());
    }
    */
    return data;
  }

  @override
  String header() {
    return type!;
  }

  @override
  String basePath() {
    return "/${PageNames.types}";
  }

  @override
  String paramsPath() {
    return "/${category!.id}";
  }

  @override
  String? defaultNextPage() {
    return PageNames.brands;
  }

  final List<Product> _products = List.empty(growable: true);

  void _initProducts() {
    for (var i = 0; i < brands.length; i++) {
      _products.addAll(brands.elementAt(i).products);
    }
  }

  List<Product> typeProducts(){
    return _products;
  }

  @override
  List<MyModel>? subList() {
    return brands;
  }

  @override
  String toString() {
    return type!;
  }

  static List<ClothingType> clothingTypesFromJson(
          dynamic str, Category category) =>
      List<ClothingType>.from(
          (str).map((x) => ClothingType(category: category).fromJson(x)));
}
