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
  late int attempts;
  Future<User?>? _user;
  @override
  void initState() {
    super.initState();
    attempts = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login"),
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
          _user != null
              ? FutureBuilder(
                  future: _user,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<User?> snapshot,
                  ) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      default:
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          if (snapshot.hasData) {
                            _login(snapshot.data!);
                            return const Text(
                              "Sucess",
                            );
                          }
                          return Text(
                              "Invalid Credentials , $attempts attempts",
                              style: const TextStyle(color: Colors.red));
                        }
                    }
                  },
                )
              : _errorMessage != null
                  ? Text(_errorMessage!,
                      style: const TextStyle(color: Colors.red))
                  : Container(),
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
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.purple),
              ),
              onPressed: () async {
                attempts = attempts + 1;
                if (attempts > 9) {
                  GoRouter.of(context).goNamed(PageNames.home);
                }
                String email = _emailController.text;
                String password = _pwdController.text;
                if (email.isEmpty || password.isEmpty) {
                  setState(() {
                    _errorMessage =
                        "Please Provide the Values, $attempts attempts";
                  });
                  return;
                }
                if (!EmailValidator.validate(email)) {
                  setState(() {
                    _errorMessage = "Not a Valid Email, $attempts attempts";
                  });
                  return;
                }
                setState(() {
                  _user = UserService.logInUser(email, password);
                });
              },
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

  void _login(User user) async {
    if (user.status == Status.verified) {
      await SessionManager().set(Constants.loggedInUser, user);
      if (context.mounted) {
        GoRouter.of(context).pushReplacementNamed(PageNames.home);
      }
    } else if (user.status == Status.pending) {
      GoRouter.of(context).pop();
      GoRouter.of(context).pushNamed(PageNames.verify, extra: user);
    }
  }
}
