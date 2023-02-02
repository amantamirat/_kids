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
            key: key,
            title: "${selectedType.type} Brands",
            myList: selectedType.brands,
            editPage: PageNames.editBrand,
            nextPage: PageNames.products);

  @override
  State<BrandList> createState() => _BrandList();
}

class _BrandList extends MyModelPageState<BrandList> {
  @override
  void onCreatePressed() {
    context.pushNamed(PageNames.addBrand,
        extra: Brand(type: widget.selectedType));
  }
}
