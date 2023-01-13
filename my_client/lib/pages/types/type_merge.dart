import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

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
  late String appBarTitle =
      "Add ${widget.selectedType.category!.title} Clothing Type";
  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      _typeController.text = widget.selectedType.type ?? '';
      appBarTitle = "Edit ${widget.selectedType.type} Clothing Type";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: Form(key: globalFormKey, child: _typeForm()),
    ));
  }

  Widget _typeForm() {
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
                    decoration: const InputDecoration(hintText: "Type Name"),
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
                        if (await MyService.saveItem(
                            clothingType, widget.editMode)) {
                          Fluttertoast.showToast(
                              msg: widget.editMode
                                  ? 'Saved'
                                  : " Saved with id ${clothingType.id}",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.yellow);
                          if (!widget.editMode) {
                            //clothingType.brands = List.empty(growable: true);
                            clothingType.category!.clothingTypes
                                .add(clothingType);
                          }
                          context.pop();
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
}
