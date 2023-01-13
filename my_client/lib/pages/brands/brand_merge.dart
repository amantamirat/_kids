import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class BrandMerge extends StatefulWidget {
  final bool editMode;
  final Brand selectedBrand;
  const BrandMerge(
      {Key? key, required this.editMode, required this.selectedBrand})
      : super(key: key);
  @override
  State<BrandMerge> createState() => _BrandMerge();
}

class _BrandMerge extends State<BrandMerge> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late String appBarTitle = "Add Brand";
  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      _nameController.text = widget.selectedBrand.name ?? '';
      appBarTitle = "Edit Brand";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: Form(key: globalFormKey, child: brandForm()),
    ));
  }

  Widget brandForm() {
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
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: "Brand Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Brand name, can not be empty, what are you thinking?';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () async {
                      if (globalFormKey.currentState!.validate()) {
                        final brand = widget.selectedBrand;
                        brand.name = _nameController.text;

                        if (await MyService.saveItem(brand, widget.editMode)) {
                          Fluttertoast.showToast(
                              msg: 'Saved',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.yellow);
                              if (!widget.editMode) {                           
                            brand.type!.brands
                                .add(brand);
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
