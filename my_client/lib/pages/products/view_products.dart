import 'package:abdu_kids/model/brand.dart';
import 'package:abdu_kids/model/product.dart';
import 'package:abdu_kids/model/type.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewProducts extends StatefulWidget {
  final ClothingType selectedType;
  const ViewProducts({Key? key, required this.selectedType}) : super(key: key);

  @override
  State<ViewProducts> createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  late List<Product> productList = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.selectedType.brands.length; i++) {
      productList.addAll(widget.selectedType.brands.elementAt(i).products);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.selectedType.type} Products"),
          elevation: 0,
        ),
        backgroundColor: Colors.grey[200],
        body: _displayProducts(productList));
  }

  Widget _displayProducts(List<Product> products) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 4,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            final product = products.elementAt(index);
            return Card(
              color: Colors.amber,
              child: Stack(
                children: [
                  Ink.image(
                    image: NetworkImage(Constants.getImageURL(product.id)),
                    fit: BoxFit.fill,
                    onImageError: (exception, stackTrace) => {
                      Image.asset(Constants.noImageAssetPath, fit: BoxFit.fill)
                    },
                    child: InkWell(
                      onTap: () {
                        context.pushNamed('view_kinds', extra: product);
                      },
                    ),
                  ),
                  Text("${product.brand!.name}-${product.detail} /${product.size}/ (${product.price} Birr)",
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,                          
                          backgroundColor: Colors.amber)),
                ],
              ),
            );
          }),
    );
  }
}