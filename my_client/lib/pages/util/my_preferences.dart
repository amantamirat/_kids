import 'package:abdu_kids/services/preference_util.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class MySharedPreferences extends StatefulWidget {
  const MySharedPreferences({Key? key}) : super(key: key);
  @override
  MySharedPreferencesState createState() => MySharedPreferencesState();
}

class MySharedPreferencesState extends State<MySharedPreferences> {  
  final _hostAddressController = TextEditingController();
  late String _hostAddress;

  @override
  void initState() {
    super.initState();
    _hostAddress = SharedPrefs.hostURL();
    _hostAddressController.text = _hostAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurations'),
      ),
      body: _myForm(),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateParams,
        tooltip: 'Apply Changes',
        child: const Icon(Icons.update),
      ),
    );
  }

  void _updateParams() {
    final SharedPreferences prefs = SharedPrefs.instance;
    final String hostAddress = _hostAddressController.text;
    prefs.setString(SharedPrefs.keyHostAddress, hostAddress);
    //GoRouter.of(context).pop();
    GoRouter.of(context).goNamed(PageNames.home);
  }

  Widget _myForm() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[            
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
                top: 10,
              ),
              child: TextFormField(
                controller: _hostAddressController,
                decoration:
                    const InputDecoration(hintText: "Server Host Address"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a vlaue for Host Address';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
