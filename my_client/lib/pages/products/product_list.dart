import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductList extends StatefulWidget {
  final Brand selectedBrand;
  const ProductList({Key? key, required this.selectedBrand}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late List<Product> productList;

  @override
  void initState() {
    super.initState();
    productList = widget.selectedBrand.products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.selectedBrand.name} Products"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: displayProds(productList),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('add_product',
              extra: Product(brand: widget.selectedBrand));
        },
        backgroundColor: Colors.green,
        tooltip: 'Add Types',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget displayProds(products) {
    return products.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.amber[index * 10],
                child: ListTile(
                  title: Center(
                      child: Text(
                    "${products[index].brand.name} Size ${products[index].size}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  leading: GestureDetector(
                    onTap: () {
                      context.pushNamed('upload_image',
                          extra: products[index].id);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      child: Image.network(
                        Constants.getImageURL(products[index].id),
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(Constants.noImageAssetPath);
                        },
                      ),
                    ),
                  ),
                  onTap: () {
                    context.pushNamed('kinds', extra: products[index]);
                  },
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.edit),
                          onTap: () {
                            context.pushNamed('edit_product',
                                extra: products[index]);
                          },
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Delete Product'),
                                content: const Text('Are you sure, proceed?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (await MyService.deleteModel(
                                          products[index])) {
                                        Fluttertoast.showToast(
                                            msg: 'Removed!',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.yellow);
                                        productList.removeAt(index);
                                        setState(() {});
                                        context.pop();
                                      }
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          )
        : const Center(child: Text('No Products Found!'));
  }
}
