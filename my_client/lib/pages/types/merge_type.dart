import 'package:abdu_kids/model/type.dart';

import 'package:abdu_kids/pages/my_merge_page.dart';
import 'package:abdu_kids/pages/my_page.dart';

import 'package:flutter/material.dart';

class MergeType extends MyPage {
  const MergeType({Key? key, required super.wrapper}) : super(key: key);
  @override
  State<MergeType> createState() => _MergeType();
}

class _MergeType extends MyMergePageState<MergeType> {
  final _typeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (editMode) {
      _typeController.text = (myModel as ClothingType).type!;
    }
    appBarTitle = "Type";
  }

  @override
  Widget formBody() {
    return Column(
      children: <Widget>[
        makeInput(
            label: "Type Name",
            controller: _typeController,
            keyboardType: TextInputType.text),
      ],
    );
  }

  @override
  void onSavePressed() {
    if (MyMergePageState.globalFormKey.currentState!.validate()) {
      final type = myModel as ClothingType;
      type.type = _typeController.text;
      super.save();
    }
  }

  @override
  void onSaveCompleted() {
    if (!editMode) {
      (myModel as ClothingType)
          .category!
          .clothingTypes
          .add(myModel as ClothingType);          
    }
  }
}
