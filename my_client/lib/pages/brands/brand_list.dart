import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/pages/model/my_model_page.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BrandList extends MyModelPage {
  final ClothingType selectedType;
  BrandList({
    Key? key,
    required this.selectedType,
  }) : super(
            title: "${selectedType.type} Brands",
            myList: selectedType.brands,
            editPage: PageName.editBrand,
            nextPage: PageName.products);

  @override
  State<BrandList> createState() => _BrandList();
}

class _BrandList extends MyModelPageState<BrandList> {
  @override
  void onCreatePressed() {
    context.pushNamed(PageName.addBrand,
        extra: Brand(type: widget.selectedType));
  }
}
