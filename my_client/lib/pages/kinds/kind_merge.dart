import 'package:abdu_kids/model/kind.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

class KindMerge extends StatefulWidget {
  final bool editMode;
  final Kind selectedKind;
  const KindMerge(
      {Key? key, required this.editMode, required this.selectedKind})
      : super(key: key);
  @override
  State<KindMerge> createState() => _KindMerge();
}

class _KindMerge extends State<KindMerge> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final _colorController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String appBarTitle = "Add Kind to Store";
    if (widget.editMode) {
      _colorController.text = widget.selectedKind.color ?? '';
      _quantityController.text = "${widget.selectedKind.quantity}";
      appBarTitle = "Edit Kind/Store";
    }
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: Form(key: globalFormKey, child: kindForm()),
    ));
  }

  Widget kindForm() {
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
                    controller: _colorController,
                    decoration: const InputDecoration(hintText: "Color"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide color kind of ${widget.selectedKind.product!.brand!.name}';
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
                      maxLines: null,
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(hintText: "Quantity")),
                ),
                ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () async {
                      if (globalFormKey.currentState!.validate()) {
                        final kind = widget.selectedKind;
                        kind.color = _colorController.text;
                        kind.quantity = int.parse(_quantityController.text);
                        /*ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Processing Request...')),
                        );*/
                        if (await MyService.saveItem(kind, widget.editMode)) {
                          Fluttertoast.showToast(
                              msg: 'Saved',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.yellow);
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
