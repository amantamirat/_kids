import 'package:abdu_kids/model/product.dart';

import 'package:abdu_kids/pages/my_merge_page.dart';
import 'package:abdu_kids/pages/my_page.dart';

import 'package:flutter/material.dart';

class MergeProduct extends MyPage {
  const MergeProduct({Key? key, required super.wrapper}) : super(key: key);
  @override
  State<MergeProduct> createState() => _MergeProduct();
}

class _MergeProduct extends MyMergePageState<MergeProduct> {
  final _detailController = TextEditingController();
  final _sizeController = TextEditingController();
  final _priceController = TextEditingController();
  final _moqController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (editMode) {
      _detailController.text = (myModel as Product).detail ?? '';
      _sizeController.text = "${(myModel as Product).size}";
      _priceController.text = "${(myModel as Product).price}";
      _moqController.text = "${(myModel as Product).moq}";
    }
    appBarTitle = "Product";
  }

  @override
  Widget formBody() {
    return Column(
      children: <Widget>[
        makeInput(
            label: "Detail",
            controller: _detailController,
            keyboardType: TextInputType.text),
        makeInput(
            label: "Size",
            controller: _sizeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true)),
        makeInput(
            label: "MOQ",
            controller: _moqController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true)),
        makeInput(
            label: "Price",
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions()),
      ],
    );
  }

  @override
  void onSavePressed() {
    if (MyMergePageState.globalFormKey.currentState!.validate()) {
      final product = myModel as Product;
      product.detail = _detailController.text;
      product.size = int.parse(_sizeController.text);
      product.price = num.parse(_priceController.text);
      product.moq = num.parse(_moqController.text);
      super.save();
    }
  }

  @override
  void onSaveCompleted() {
    if (!editMode) {
      (myModel as Product).brand!.products.add(myModel as Product);
    }
  }
}
