import 'dart:async';
import 'package:abdu_kids/util/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences extends StatefulWidget {
  
  const MySharedPreferences({Key? key}) : super(key: key);

  @override
  MySharedPreferencesState createState() => MySharedPreferencesState();
}

class MySharedPreferencesState extends State<MySharedPreferences> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _protocolController = TextEditingController();
  final _hostAddressController = TextEditingController();
  final _portNumberController = TextEditingController();

  late Future<String> _protocol;
  late Future<String> _hostAddress;
  late Future<int> _portNumber;

  Future<void> _updateParams() async {
    final SharedPreferences prefs = await _prefs;
    final String protocol = _protocolController.text;
    final String hostAddress = _hostAddressController.text;
    final int portNumber = int.parse(_portNumberController.text);
    setState(() {
      _protocol = prefs
          .setString(SharedPrefs.keyProtocol, protocol)
          .then((bool success) {
        return protocol;
      });
      _hostAddress = prefs
          .setString(SharedPrefs.keyHostAddress, hostAddress)
          .then((bool success) {
        return hostAddress;
      });
      _portNumber = prefs
          .setInt(SharedPrefs.keyPortNumber, portNumber)
          .then((bool success) {
        return portNumber;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _protocol = _prefs.then((SharedPreferences prefs) {
      return prefs.getString(SharedPrefs.keyProtocol) ?? 'http';
    });
    _hostAddress = _prefs.then((SharedPreferences prefs) {
      return prefs.getString(SharedPrefs.keyHostAddress) ?? 'localhost';
    });
    _portNumber = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt(SharedPrefs.keyPortNumber) ?? 8080;
      //return 8080;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurations'),
      ),
      body: FutureBuilder(
          future: Future.wait([_protocol, _hostAddress, _portNumber]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  _protocolController.text = snapshot.data![0];
                  _hostAddressController.text = snapshot.data![1];
                  _portNumberController.text = "${snapshot.data![2]}";
                  print(snapshot.data![0]);
                  print(snapshot.data![1]);
                  print(snapshot.data![2]);
                  return myForm();
                }
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateParams,
        tooltip: 'Apply Changes',
        child: const Icon(Icons.update),
      ),
    );
  }

  Widget myForm() {
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
                  child: TextField(
                      controller: _protocolController,
                      decoration: const InputDecoration(hintText: "Protocol")),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                  ),
                  child: TextField(
                      controller: _hostAddressController,
                      decoration: const InputDecoration(
                          hintText: "Server Host Address")),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                  ),
                  child: TextField(
                      controller: _portNumberController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(hintText: "Port Number")),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
