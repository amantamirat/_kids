import 'package:abdu_kids/pages/my_page.dart';
import 'package:flutter/material.dart';


class MyGridPage extends MyPage {
  const MyGridPage({Key? key, required super.wrapper}) : super(key: key);
  @override
  State<MyGridPage> createState() => _MyGridPage();
}

class _MyGridPage extends MyPageState<MyGridPage> {
  //add suffix title to the bar based on the class type
}
