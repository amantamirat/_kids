import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ChangePassword extends StatefulWidget {
  final User selectedUser;
  const ChangePassword({Key? key, required this.selectedUser})
      : super(key: key);
  @override
  State<ChangePassword> createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
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
                    label: "Current Password", controller: _passwordController),
                _makeInput(
                    label: "New Password", controller: _newPasswordController),
                _makeInput(
                    label: "Confirm New Password",
                    controller: _confirmPasswordController),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: _errorMessage == null
                      ? Container()
                      : Text(_errorMessage!,
                          style: const TextStyle(color: Colors.red)),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                    child: const Text("Change"),
                    onPressed: () async {
                      if (globalFormKey.currentState!.validate()) {
                        String password = _passwordController.text;
                        String newPassword = _newPasswordController.text;
                        String confpassword = _confirmPasswordController.text;
                        if (password.isEmpty ||
                            newPassword.isEmpty ||
                            confpassword.isEmpty) {
                          setState(() {
                            _errorMessage =
                                "Please Provide the required Values";
                          });
                          return;
                        }

                        if (newPassword != confpassword) {
                          setState(() {
                            _errorMessage = "Passwords are Mismatched!";
                          });
                          return;
                        }
                        String? message = await UserService.changePassword(
                            widget.selectedUser.id!,
                            password,
                            newPassword,
                            widget.selectedUser.token!);
                        if (message == null) {
                          Fluttertoast.showToast(
                              msg: 'Changed',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.yellow);
                          if (context.mounted) {
                            context.pop();
                          }
                        } else {
                          setState(() {
                            _errorMessage = message;
                          });
                          return;
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

  Widget _makeInput({label, controller, obsureText = true}) {
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
