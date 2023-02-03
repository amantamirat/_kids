import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/services/user_service.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:email_validator/email_validator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  static final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pwdController = TextEditingController();
  final _confPwdController = TextEditingController();
  String? _errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Sign up Page"),
      ),
      body: SafeArea(
        child: Form(key: _globalFormKey, child: _registerForm()),
      ),
    );
  }

  Widget _registerForm() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(4),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create an Account, Its free!",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _makeInput(label: "Email", controller: _emailController),
                      _makeInput(
                          label: "Phone Number", controller: _phoneController),
                      _makeInput(
                          label: "Password",
                          controller: _pwdController,
                          obsureText: true),
                      _makeInput(
                          label: "Confirm Pasword",
                          controller: _confPwdController,
                          obsureText: true),
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: const Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black))),
                    child: MaterialButton(
                      height: 50,
                      onPressed: () async {
                        String email = _emailController.text;
                        String phoneNumber = _phoneController.text;
                        String password = _pwdController.text;
                        String confpassword = _confPwdController.text;
                        if (email.isEmpty ||
                            phoneNumber.isEmpty ||
                            password.isEmpty ||
                            confpassword.isEmpty) {
                          setState(() {
                            _errorMessage =
                                "Please Provide the required Values";
                          });
                          return;
                        }
                        if (!EmailValidator.validate(email)) {
                          setState(() {
                            _errorMessage = "Not a Valid Email";
                          });
                          return;
                        }
                        if (password != confpassword) {
                          setState(() {
                            _errorMessage = "Passwords are Mismatched";
                          });
                          return;
                        }
                        User user = User();
                        user.email = email;
                        user.password = password;
                        user.role = Role.customer;
                        user.status = Status.pending;
                        user.phoneNumber = phoneNumber;
                        bool registered = await UserService.registerUser(user);
                        if (!registered) {
                          setState(() {
                            _errorMessage = user.message;
                          });
                          return;
                        }
                        if (context.mounted) {                          
                          GoRouter.of(context).pop();
                          context.pushNamed(PageNames.verify, extra: user);
                        }
                      },
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      child: const Text('Log in',
                          style: TextStyle(color: Colors.purple)),
                      onPressed: () {
                        context.pop();
                        context.pushNamed(PageNames.login);
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
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
