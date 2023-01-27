import 'package:abdu_kids/model/util/cart_item.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:abdu_kids/services/database_util.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:go_router/go_router.dart';

class ShoppingCart extends StatefulWidget {
  
  const ShoppingCart({
    super.key,
  });
  @override
  State<ShoppingCart> createState() => _ShoppingCart();
}

class _ShoppingCart extends State<ShoppingCart> {
  late Future<List<CartItem>?> _myFuture;
  late List<CartItem> _myList;

  @override
  void initState() {
    super.initState();
    _myFuture = CartDataBase.cartItems();
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
      future: _myFuture,
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
              _myList = snapshot.data!;
              return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: _myList.isNotEmpty
                      ? _displayList()
                      : const Center(child: Text('Empty Cart!')));
            }
        }
      },
    );
  }

  Widget _displayList() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: _myList.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _myList.elementAt(index);
        if (item.selectedKind == null) {
          CartDataBase.deleteItem(item.id);
          return Container();
        }
        return ListTile(
          title: Center(
              child: Text(
            item.selectedKind!.header(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          )),
          subtitle: Center(
            child: Text(
                "Price: ${item.quantity * item.selectedKind!.product!.price} Birr"),
          ),
          leading: CachedNetworkImage(
            imageUrl: Constants.getImageURL(item.id),
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => Image.asset(
              Constants.noImageAssetPath,
              width: 80,
              height: 80,
            ),
          ),
          onTap: () {
            context.pushNamed(PageName.kinds, extra: item.selectedKind);
          },
          trailing: SizedBox(
            width: 120,
            height: 40,
            child: SpinBox(
              min: 0,
              step: item.selectedKind!.product!.moq.toDouble(),
              max: item.selectedKind!.quantity!.toDouble(),
              value: item.quantity.toDouble(),
              textStyle: const TextStyle(fontSize: 12),
              iconSize: 12,
              readOnly: true,
              onChanged: (value) async {
                if (value == 0) {
                  int result = await CartDataBase.deleteItem(item.id);
                  if (result == 1) {
                    setState(() {
                      _myList.remove(item);
                    });
                  }
                  return;
                }
                setState(() {
                  item.quantity = value.toInt();
                });
                CartDataBase.updateCartItem(item);
              },
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
