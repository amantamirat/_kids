import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/pages/util/delete_dialog.dart';
import 'package:abdu_kids/services/my_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  Widget displayProds(List<Product> products) {
    return products.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              final product = products.elementAt(index);
              return Container(
                color: Colors.amber[index * 10],
                child: ListTile(
                  title: Center(
                      child: Text(
                    "${product.brand!.name} ${product.toString()} Size ${product.size}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  leading: GestureDetector(
                    onTap: () {
                      context.pushNamed('upload_image', extra: product.id);
                    },
                    child: CachedNetworkImage(
                        imageUrl: Constants.getImageURL(product.id),
                        imageBuilder: (context, imageProvider) => Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset(
                              Constants.noImageAssetPath,
                              width: 200,
                              height: 200,
                            )),
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
                            context.pushNamed('edit_product', extra: product);
                          },
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () async {
                            int? result = await showDialog<int>(
                                context: context,
                                builder: (BuildContext context) =>
                                    DeleteDialog(model: product));
                            if (result == 0) {
                              setState(() {
                                productList.remove(product);
                              });
                            }
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
