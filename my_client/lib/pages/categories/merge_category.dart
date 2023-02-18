import 'package:abdu_kids/model/category.dart';

import 'package:abdu_kids/pages/my_merge_page.dart';
import 'package:abdu_kids/pages/my_page.dart';

import 'package:flutter/material.dart';

class MergeCategory extends MyPage {
  const MergeCategory({Key? key, required super.wrapper}) : super(key: key);
  @override
  State<MergeCategory> createState() => _MergeCategory();
}

class _MergeCategory extends MyMergePageState<MergeCategory> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (editMode) {
      _titleController.text = (myModel as Category).title ?? '';
      _descriptionController.text = (myModel as Category).description ?? '';
    }
    appBarTitle = "Category";
  }

  @override
  Widget formBody() {
    return Column(
      children: <Widget>[
        makeInput(
            label: "Title",
            controller: _titleController,
            keyboardType: TextInputType.text),
        makeInput(
            label: "Description",
            controller: _descriptionController,
            keyboardType: TextInputType.multiline),
      ],
    );
  }

  @override
  void onSavePressed() {
    if (MyMergePageState.globalFormKey.currentState!.validate()) {
      final category = myModel as Category;
      category.title = _titleController.text;
      category.description = _descriptionController.text;
      super.save();
    }
  }  
}
