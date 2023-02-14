import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class EditProfile extends StatefulWidget {
  final User loggedInUser;
  const EditProfile({Key? key, required this.loggedInUser}) : super(key: key);
  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();

  late String appBarTitle = "Edit Profile";
  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.loggedInUser.firstName ?? '';
    _lastNameController.text = widget.loggedInUser.lastName ?? '';
    _phoneNumberController.text = widget.loggedInUser.phoneNumber ?? '';
    _addressController.text = widget.loggedInUser.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text(appBarTitle),
      actions: <Widget>[
        IconButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(PageNames.changePassword, extra: widget.loggedInUser);
                  },
                  icon: const Icon(Icons.password),
                )
      ]
      ),
      body: Form(key: globalFormKey, child: _myForm()),
    ));
  }

  Widget _myForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: Column(
              children: <Widget>[
                _makeInput(
                    label: "First Name", controller: _firstNameController),
                _makeInput(label: "Last Name", controller: _lastNameController),
                _makeInput(
                    label: "Phone Number", controller: _phoneNumberController),
                _makeInput(label: "Address", controller: _addressController),
                const SizedBox(height: 25),
                ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () async {
                      if (globalFormKey.currentState!.validate()) {
                        final user = widget.loggedInUser;
                        user.firstName = _firstNameController.text;
                        user.lastName = _lastNameController.text;
                        user.phoneNumber = _phoneNumberController.text;
                        user.address = _addressController.text;
                        if (await MyService.saveItem(user, true)) {
                          Fluttertoast.showToast(
                              msg: 'Saved',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.yellow);
                          if (context.mounted) {
                            context.pop();
                          }
                        }
                      }
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _makeInput({label, controller, obsureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          obscureText: obsureText,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.grey,
            )),
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
