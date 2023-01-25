import 'package:abdu_kids/model/util/cart_item.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:abdu_kids/services/database_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({
    super.key,
  });
  @override
  State<ShoppingCart> createState() => _ShoppingCart();
}

class _ShoppingCart extends State<ShoppingCart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: _loadCartItems(),
    );
  }

  Widget _loadCartItems() {
    return FutureBuilder(
      future: CartDataBase.cartItems(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<CartItem>?> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${snapshot.error}'),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: _displayList(snapshot.data!),
              );
            }
        }
      },
    );
  }

  Widget _displayList(List<CartItem> myList) {
    return myList.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            itemCount: myList.length,
            itemBuilder: (BuildContext context, int index) {
              final item = myList.elementAt(index);
              return ListTile(
                title: Center(
                    child: Text(
                  item.selectedKind!.header(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                leading: CachedNetworkImage(
                  imageUrl: Constants.getImageURL(item.id),
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
                    width: 80,
                    height: 80,
                  ),
                ),
                onTap: () {
                  //context.pushNamed(widget.nextPage!, extra: model);
                },
                trailing: SizedBox(
                  width: 120,
                  height: 40,
                  child: SpinBox(
                    min: 0,
                    step: 4,
                    max: 100,
                    value: item.quantity.toDouble(),
                    textStyle: const TextStyle(fontSize: 12),
                    iconSize: 12,
                    readOnly: true,
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          )
        : const Center(child: Text('Empty Cart!'));
  }
}
