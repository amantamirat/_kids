import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

class ProductMerge extends StatefulWidget {
  final bool editMode;
  final Product selectedProduct;
  const ProductMerge(
      {Key? key, required this.editMode, required this.selectedProduct})
      : super(key: key);
  @override
  State<ProductMerge> createState() => _ProductMerge();
}

class _ProductMerge extends State<ProductMerge> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sizeController = TextEditingController();
  final _priceController = TextEditingController();
  late String appBarTitle = "Add Product";
  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      _nameController.text = widget.selectedProduct.name ?? '';
      _descriptionController.text = widget.selectedProduct.description ?? '';
      _sizeController.text = "${widget.selectedProduct.size}";
      _priceController.text = "${widget.selectedProduct.price}";
      appBarTitle = "Edit Product";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: Form(key: globalFormKey, child: productForm()),
    ));
  }

  Widget productForm() {
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
                    decoration: const InputDecoration(hintText: "Product Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter clothing type name';
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
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(hintText: "Product Description"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                  ),
                  child: TextFormField(
                    controller: _sizeController,
                    decoration: const InputDecoration(hintText: "Product Size"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter clothing size';
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
                    controller: _priceController,
                    decoration: const InputDecoration(hintText: "Product Price"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter clothing price';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () async {
                      if (globalFormKey.currentState!.validate()) {
                        final product = widget.selectedProduct;
                        product.name = _nameController.text;
                        product.description = _descriptionController.text;
                        product.size = int.parse(_sizeController.text);
                        product.price = num.parse(_priceController.text);
                        if (await MyService.saveItem(
                            product, widget.editMode)) {
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
