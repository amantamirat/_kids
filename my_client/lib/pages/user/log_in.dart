import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/services/user_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  String? _errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Form(key: _globalFormKey, child: _logInForm()),
    );
  }

  Widget _logInForm() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
              child: Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Image.asset('assets/images/CoffeeCup.jpg')),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email id as abc@gmail.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: _pwdController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter secure password'),
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
            height: 20,
          ),
          TextButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            child: const Text('Forgot Password',
                style: TextStyle(color: Colors.purple)),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _pwdController.text;
                if (email.isEmpty || password.isEmpty) {
                  setState(() {
                    _errorMessage = "Please Provide the Values";
                  });
                  return;
                }
                if (!EmailValidator.validate(email)) {
                  setState(() {
                    _errorMessage = "Not a Valid Email";
                  });
                  return;
                }
                User? loggedInUser =
                    await UserService.logInUser(email, password);
                if (loggedInUser == null) {
                  setState(() {
                    _errorMessage = "Invalid Credentials";
                  });
                  return;
                }
                if (context.mounted) {
                  if (loggedInUser.status == Status.verified) {
                    SessionManager().set(Constants.loggedInUser, loggedInUser);
                    GoRouter.of(context).pop();
                  } else if (loggedInUser.status == Status.pending) {
                    GoRouter.of(context).pop();
                    context.pushNamed(PageNames.verify, extra: loggedInUser);
                  }
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('New User?'),
              TextButton(
                child: const Text('Create Account',
                    style: TextStyle(color: Colors.purple)),
                onPressed: () {
                  context.pop();
                  context.pushNamed(PageNames.register);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
