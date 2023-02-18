import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/pages/my_merge_page.dart';
import 'package:abdu_kids/pages/my_page.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfile extends MyPage {
  const EditProfile({Key? key, required super.wrapper}) : super(key: key);
  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends MyMergePageState<EditProfile> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _firstNameController.text = (myModel as User).firstName ?? '';
    _lastNameController.text = (myModel as User).lastName ?? '';
    _phoneNumberController.text = (myModel as User).phoneNumber ?? '';
    _addressController.text = (myModel as User).address ?? '';
    appBarTitle = "Edit Profile";
  }

  @override
  List<Widget>? appBarActions() {
    return <Widget>[
      IconButton(
        onPressed: () {
          GoRouter.of(context)
              .pushNamed(PageNames.changePassword, extra: loggedInUser);
        },
        icon: const Icon(Icons.password),
      )
    ];
  }

  @override
  Widget formBody() {
    return Column(
      children: <Widget>[
        makeInput(
            label: "First Name",
            controller: _firstNameController,
            required: false),
        makeInput(
            label: "Last Name",
            controller: _lastNameController,
            required: false),
        makeInput(
            label: "Phone Number",
            controller: _phoneNumberController,
            required: false),
        makeInput(
            label: "Address", controller: _addressController, required: false),
      ],
    );
  }

  @override
  void onSavePressed() {
    final user = myModel as User;
    user.firstName = _firstNameController.text;
    user.lastName = _lastNameController.text;
    user.phoneNumber = _phoneNumberController.text;
    user.address = _addressController.text;
    save();
  }
}
