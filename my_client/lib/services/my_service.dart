import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/model/util/cart_item.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../util/constants.dart';

class MyService {
  static var client = http.Client();

  static late List<Category>? myRootData;

  static Future<List<Category>?> getCategories() async {
    String url = "${Constants.apiURL()}/${PageNames.categories}";
    var response = await client.get(
      Uri.parse(url),
      headers: Constants.requestHeaders,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      myRootData = Category.categoriesFromJson(data[PageNames.categories]);
      return myRootData;
    } else {
      return null;
    }
  }

  static Future<bool> saveItem(MyModel myModel, bool isEditMode) async {
    String url = "${Constants.apiURL()}${myModel.basePath()}";
    var response = http.Response("{}", 404);
    if (isEditMode) {
      url = "$url${Constants.updatePath}${myModel.paramsPath()}/${myModel.id}";
      response = await http.patch(
        Uri.parse(url),
        headers: Constants.requestHeaders,
        body: jsonEncode(myModel.toJson()),
      );
    } else {
      url = "$url${Constants.newPath}${myModel.paramsPath()}";
      response = await http.post(
        Uri.parse(url),
        headers: Constants.requestHeaders,
        body: jsonEncode(myModel.toJson(includeId: false)),
      );
    }

    var data = jsonDecode(response.body);
    if (response.statusCode != 201) {
      myModel.message = data["message"];
      return false;
    }
    myModel.id = data["data"]["_id"];
    return true;
  }

  static Future<bool> deleteModel(MyModel myModel) async {
    String url =
        "${Constants.apiURL()}${myModel.basePath()}${Constants.deletePath}${myModel.paramsPath()}/${myModel.id}";
    var response = await client.delete(
      Uri.parse(url),
      headers: Constants.requestHeaders,
    );
    return response.statusCode == 204;
  }

  static Kind? findKind(CartItem item) {
    for (Category category in myRootData!) {
      if (category.id == item.categoryId) {
        for (ClothingType type in category.clothingTypes) {
          if (type.id == item.typeId) {
            for (Brand brand in type.brands) {
              if (brand.id == item.brandId) {
                for (Product product in brand.products) {
                  if (product.id == item.productId) {
                    for (Kind kind in product.kinds) {
                      if (kind.id == item.kindId) {
                        return kind;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return null;
  }
}
