import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/pages/model/my_model_page.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductList extends MyModelPage {
  final MyModel selectedModel;

  ProductList({Key? key, required this.selectedModel})
      : super(
            key: key,
            myList: _getProducts(selectedModel),
            title: "${selectedModel.toString()} Products",
            showManageIcon: selectedModel is Brand,
            editPage: PageNames.editProduct,
            nextPage: PageNames.kinds);

  static List<Product> _getProducts(MyModel model) {
    if (model is Brand) {
      return model.products;
    }
    if (model is ClothingType) {
      List<Product> products = List.empty(growable: true);
      for (var i = 0; i < model.brands.length; i++) {
        products.addAll(model.brands.elementAt(i).products);
      }
      return products;
    }
    return List.empty();
  }

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends MyModelPageState<ProductList> {
  @override
  void onCreatePressed() {
    if (widget.selectedModel is Brand) {
      context.pushNamed(PageNames.addProduct,
          extra: Product(brand: widget.selectedModel as Brand));
    }
  }
}
