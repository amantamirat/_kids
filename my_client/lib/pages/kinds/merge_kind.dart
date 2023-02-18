import 'package:abdu_kids/model/kind.dart';

import 'package:abdu_kids/pages/my_merge_page.dart';
import 'package:abdu_kids/pages/my_page.dart';

import 'package:flutter/material.dart';

class MergeKind extends MyPage {
  const MergeKind({Key? key, required super.wrapper}) : super(key: key);
  @override
  State<MergeKind> createState() => _MergeKind();
}

class _MergeKind extends MyMergePageState<MergeKind> {
  final _colorController = TextEditingController();
  final _quantityController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (editMode) {
      _colorController.text = (myModel as Kind).color ?? '';
      _quantityController.text = "${(myModel as Kind).quantity}";
    }
    appBarTitle = "Kind";
  }

  @override
  Widget formBody() {
    return Column(
      children: <Widget>[
        makeInput(
            label: "Color",
            controller: _colorController,
            keyboardType: TextInputType.text),
        makeInput(
            label: "Quantity",
            controller: _quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true)),
      ],
    );
  }

  @override
  void onSavePressed() {
    if (MyMergePageState.globalFormKey.currentState!.validate()) {
      final kind = myModel as Kind;
      kind.color = _colorController.text;
      kind.quantity = int.parse(_quantityController.text);
      super.save();
    }
  }

  @override
  void onSaveCompleted() {
    if (!editMode) {
      (myModel as Kind).product!.kinds.add(myModel as Kind);
    }
  }
}
