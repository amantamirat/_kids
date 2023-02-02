import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/services/user_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:go_router/go_router.dart';

class ConfirmAccount extends StatefulWidget {
  final User selectedUser;

  const ConfirmAccount({Key? key, required this.selectedUser})
      : super(key: key);
  @override
  State<ConfirmAccount> createState() => _ConfirmAccount();
}

class _ConfirmAccount extends State<ConfirmAccount> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: const Text("Confirm Code")),
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
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                  ),
                  child: TextFormField(
                    controller: _codeController,
                    decoration:
                        const InputDecoration(hintText: "Enter Your Code!"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Code, can not be empty, what are you thinking?';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: _errorMessage == null
                      ? Container()
                      : Text(_errorMessage!,
                          style: const TextStyle(color: Colors.red)),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    child: const Text("Confirm"),
                    onPressed: () async {
                      if (globalFormKey.currentState!.validate()) {
                        final user = widget.selectedUser;
                        user.verificationCode = _codeController.text;
                        bool verified = await UserService.verifyAccount(user);
                        if (verified) {
                          await SessionManager()
                              .set(Constants.loggedInUser, user);
                          if (context.mounted) {
                            GoRouter.of(context).pop();
                          }
                        } else {
                          setState(() {
                            _errorMessage = user.message;
                          });
                        }
                      }
                    }),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Not Recieved?'),
                    TextButton(
                      child: const Text('Send Again.',
                          style: TextStyle(color: Colors.purple)),
                      onPressed: () async {
                        final user = widget.selectedUser;
                        bool sent = await UserService.sendCode(user);
                        if (sent) {
                          if (context.mounted) {
                            _errorMessage = "Done!";
                          }
                        } else {
                          setState(() {
                            _errorMessage = user.message;
                          });
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
