import 'package:abdu_kids/model/brand.dart';

import 'package:abdu_kids/pages/my_merge_page.dart';
import 'package:abdu_kids/pages/my_page.dart';

import 'package:flutter/material.dart';

class MergeBrand extends MyPage {
  const MergeBrand({Key? key, required super.wrapper}) : super(key: key);
  @override
  State<MergeBrand> createState() => _MergeBrand();
}

class _MergeBrand extends MyMergePageState<MergeBrand> {
  final _nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (editMode) {
      _nameController.text = (myModel as Brand).name!;
    }
    appBarTitle = "Brand";
  }

  @override
  Widget formBody() {
    return Column(
      children: <Widget>[
        makeInput(
            label: "Brand Name",
            controller: _nameController,
            keyboardType: TextInputType.text),
      ],
    );
  }

  @override
  void onSavePressed() {
    if (MyMergePageState.globalFormKey.currentState!.validate()) {
      final brand = myModel as Brand;
      brand.name = _nameController.text;
      super.save();
    }
  }

  @override
  void onSaveCompleted() {
    if (!editMode) {
      (myModel as Brand).type!.brands.add(myModel as Brand);
    }
  }
}
