import 'package:abdu_kids/services/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class MySharedPreferences extends StatefulWidget {
  const MySharedPreferences({Key? key}) : super(key: key);
  @override
  MySharedPreferencesState createState() => MySharedPreferencesState();
}

class MySharedPreferencesState extends State<MySharedPreferences> {
  final protocolItems = const [
    DropdownMenuItem(value: "http", child: Text("http")),
    DropdownMenuItem(value: "https", child: Text("https")),
  ];
  final _hostAddressController = TextEditingController();
  final _portNumberController = TextEditingController();

  late String _protocol;
  late String _hostAddress;
  late int _portNumber;

  @override
  void initState() {
    super.initState();
    _protocol = SharedPrefs.protocol();
    _hostAddress = SharedPrefs.hostName();
    _portNumber = SharedPrefs.portNumber();
    _hostAddressController.text = _hostAddress;
    _portNumberController.text = '$_portNumber';
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
    final String protocol = _protocol;
    final String hostAddress = _hostAddressController.text;
    final int portNumber = int.parse(_portNumberController.text);
    prefs.setString(SharedPrefs.keyProtocol, protocol);
    prefs.setString(SharedPrefs.keyHostAddress, hostAddress);
    prefs.setInt(SharedPrefs.keyPortNumber, portNumber);
    GoRouter.of(context).pop();
    //GoRouter.of(context).goNamed("home");
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Protocol"),
                      const SizedBox(
                        width: 15,
                      ),
                      DropdownButton(
                        value: _protocol,
                        items: protocolItems,
                        onChanged: (value) {
                          setState(() {
                            _protocol = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                  ),
                  child: TextFormField(
                    controller: _portNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Port Number"),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a vlaue for Port Number';
                      }
                      int v = int.parse(value);
                      if (v < 0 || v > 65536) {
                        return 'Please provide a valid Port Number, in range [0, 65536]';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
