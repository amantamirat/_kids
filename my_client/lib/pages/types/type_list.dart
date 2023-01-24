import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/pages/model/my_model_page.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TypeList extends MyModelPage {
  final Category selectedCategory;
  TypeList({Key? key, required this.selectedCategory})
      : super(
            key: key,
            title: "${selectedCategory.title} Types",
            myList: selectedCategory.clothingTypes,
            editPage: PageName.editType,
            nextPage: PageName.brands,
            nextGridPage: PageName.products);

  @override
  State<TypeList> createState() => _TypeList();
}

class _TypeList extends MyModelPageState<TypeList> {
  @override
  void onCreatePressed() {
    context.pushNamed(PageName.addType,
        extra: ClothingType(category: widget.selectedCategory));
  }
}
