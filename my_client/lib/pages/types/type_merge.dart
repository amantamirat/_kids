import 'package:abdu_kids/model/type.dart';
import 'package:flutter/material.dart';

class TypeMerge extends StatefulWidget {
  final bool editMode;
  final ClothingType selectedType;
  const TypeMerge(
      {Key? key, required this.editMode, required this.selectedType})
      : super(key: key);
  @override
  State<TypeMerge> createState() => _TypeMerge();
}

class _TypeMerge extends State<TypeMerge> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  late String appBarTitle = "Add Type";
  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      _typeController.text = widget.selectedType.type ?? '';
      appBarTitle = "Edit Type";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: Form(key: globalFormKey, child: typeForm()),
    ));
  }

  Widget typeForm() {
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
                    controller: _typeController,
                    decoration:
                        const InputDecoration(hintText: "Type Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter clothing type name';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () async {
                      if (globalFormKey.currentState!.validate()) {
                        final clothingType = widget.selectedType;
                        clothingType.type = _typeController.text;
                        

                      }
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}