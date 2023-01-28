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
  //final _nameController = TextEditingController();
  final _detailController = TextEditingController();
  final _sizeController = TextEditingController();
  final _priceController = TextEditingController();
  final _moqController = TextEditingController();
  late String appBarTitle =
      "Add ${widget.selectedProduct.brand} ${widget.selectedProduct.brand!.type} Product";
  @override
  void initState() {
    super.initState();
    //_moqController.text = "${Constants.defaultMOQ()}";
    if (widget.editMode) {
      //_nameController.text = widget.selectedProduct.name ?? '';
      _detailController.text = widget.selectedProduct.detail ?? '';
      _sizeController.text = "${widget.selectedProduct.size}";
      _priceController.text = "${widget.selectedProduct.price}";
      _moqController.text = "${widget.selectedProduct.moq}";
      appBarTitle =
          "Edit ${widget.selectedProduct.brand} ${widget.selectedProduct}  Product";
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
                    controller: _detailController,
                    decoration:
                        const InputDecoration(hintText: "Product Detail"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter detail info';
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
                    decoration:
                        const InputDecoration(hintText: "Product Price"),
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
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                  ),
                  child: TextFormField(
                    controller: _moqController,
                    decoration: const InputDecoration(hintText: "Product MOQ"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'MOQ can not be empty';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () async {
                      if (globalFormKey.currentState!.validate()) {
                        final product = widget.selectedProduct;
                        //product.name = _nameController.text;
                        product.detail = _detailController.text;
                        product.size = int.parse(_sizeController.text);
                        product.price = num.parse(_priceController.text);
                        product.moq = num.parse(_moqController.text);
                        if (await MyService.saveItem(
                            product, widget.editMode)) {
                          Fluttertoast.showToast(
                              msg: 'Saved',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.yellow);
                          if (!widget.editMode) {
                            product.brand!.products.add(product);
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
