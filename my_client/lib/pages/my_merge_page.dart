import 'package:abdu_kids/model/category.dart';
import 'package:abdu_kids/model/my_model.dart';
import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/pages/my_page.dart';
import 'package:abdu_kids/util/extra_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

abstract class MyMergePage extends StatefulWidget {
  final ExtraWrapper wrapper;
  const MyMergePage({
    Key? key,
    required this.wrapper,
  }) : super(key: key);
}

abstract class MyMergePageState<T extends MyPage> extends State<T> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late User? loggedInUser;
  late MyModel? myModel;
  late bool editMode;
  String appBarTitle = "";
  Future<bool>? _saved;

  @override
  void initState() {
    super.initState();
    loggedInUser = widget.wrapper.user;
    myModel = widget.wrapper.model;
    editMode = widget.wrapper.editMode;
  }

  Widget formBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
            editMode ? "Edit ${myModel!.header()}" : "Add New $appBarTitle"),
        actions: appBarActions(),
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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(children: <Widget>[
                formBody(),
                const SizedBox(height: 25),
                FutureBuilder(
                  future: _saved,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<bool> snapshot,
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
                            if (snapshot.data!) {
                              Fluttertoast.showToast(
                                  msg: 'Saved',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.yellow);
                              if (!editMode && myModel is Category) {
                                Navigator.pop(context, myModel as Category);
                              } else {
                                GoRouter.of(context).pop();
                              }
                              onSaveCompleted();
                              return Container();
                            }
                          }
                          return Text("${myModel!.message}",
                              style: const TextStyle(color: Colors.red));
                        }
                    }
                  },
                ),
                ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () async {
                      onSavePressed();
                    }),
              ])),
        ]));
  }

  void onSaveCompleted() {}

  void onSavePressed();

  void save() async {
    if (myModel != null && loggedInUser != null) {
      setState(() {
        _saved = MyService.save(myModel!, loggedInUser!, editMode);
      });
    }
  }

  List<Widget>? appBarActions() {
    return null;
  }

  Widget makeInput(
      {label, controller, keyboardType, obsureText = false, required = true}) {
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
        TextFormField(
          controller: controller,
          obscureText: obsureText,
          keyboardType: keyboardType,
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
          validator: (value) {
            if (required) {
              if (value == null || value.isEmpty) {
                return "$label is required!";
              }
            }
            if (keyboardType == TextInputType.number) {
              if (num.tryParse(value!) == null) {
                return "$label must be a number!";
              }
            }
            return null;
          },
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
