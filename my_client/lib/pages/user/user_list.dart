import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/pages/model/my_model_page.dart';
import 'package:flutter/material.dart';

class UserList extends MyModelPage {
  final List<User> users;
  const UserList({Key? key, required this.users})
      : super(
            key: key,
            title: "Users List",
            myList: users,
            manageMode: true,
            showManageIcon: false);

  @override
  State<UserList> createState() => _UserList();
}

class _UserList extends MyModelPageState<UserList> {
  @override
  void onCreatePressed() {
    /* context.pushNamed(PageName.addBrand,
        extra: Brand(type: widget.selectedType));*/
  }
}
