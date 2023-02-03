import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/model/util/cart_item.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:abdu_kids/services/database_util.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:go_router/go_router.dart';

class ShoppingCart extends StatefulWidget {
  final User? loggedInUser;
  const ShoppingCart({super.key, this.loggedInUser});
  @override
  State<ShoppingCart> createState() => _ShoppingCart();
}

class _ShoppingCart extends State<ShoppingCart> {
  late Future<List<CartItem>?> _myFuture;
  late List<CartItem>? myList;
  late num _totalPrice = 0;
  late bool _isUserLoggedIn;
  @override
  void initState() {
    super.initState();
    _isUserLoggedIn = widget.loggedInUser != null;
    _myFuture = CartDataBase.cartItems();
  }

  @override
  Widget build(BuildContext context) {
    return _loadCartItems();
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
              myList = snapshot.data;
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('My Cart'),
                  ),
                  body: snapshot.hasData
                      ? _displayList()
                      : Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Center(child: Text('Empty Cart!'))),
                  bottomNavigationBar:
                      snapshot.hasData ? _summry() : Container());
            }
        }
      },
    );
  }

  Widget _displayList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: myList!.length,
        itemBuilder: (BuildContext context, int index) {
          final item = myList!.elementAt(index);
          if (item.selectedKind == null) {
            CartDataBase.deleteItem(item.id);
            return Container();
          }
          double moq = item.selectedKind!.product!.moq.toDouble();
          double max = item.selectedKind!.quantity!.toDouble();
          max = max - (max % moq);
          num price = item.quantity * item.selectedKind!.product!.price;
          return Card(
            color: Colors.orangeAccent.shade200,
            elevation: 5.0,
            child: ListTile(
              title: Center(
                  child: Text(
                item.selectedKind!.header(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )),
              subtitle: Center(
                child: Text("Price: $price Birr"),
              ),
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
                context.pushNamed(PageNames.kinds, extra: item.selectedKind);
              },
              trailing: SizedBox(
                width: 120,
                height: 40,
                child: SpinBox(
                  min: 0,
                  step: moq,
                  max: max,
                  value: item.quantity.toDouble(),
                  textStyle: const TextStyle(fontSize: 12),
                  iconSize: 12,
                  readOnly: true,
                  onChanged: (value) async {
                    if (value == 0) {
                      int result = await CartDataBase.deleteItem(item.id);
                      if (result == 1) {
                        setState(() {
                          _totalPrice = _totalPrice - price;
                          myList!.remove(item);
                        });
                      }
                      return;
                    }
                    setState(() {
                      _totalPrice = _totalPrice - price + value.toInt();
                      item.quantity = value.toInt();
                    });
                    CartDataBase.updateCartItem(item);
                  },
                ),
              ),
            ),
          );
        });
  }

  void _updateTotalPrice() {
    _totalPrice = 0;
    for (CartItem item in myList!) {
      _totalPrice =
          _totalPrice + item.quantity * item.selectedKind!.product!.price;
    }
  }

  Widget _summry() {
    _updateTotalPrice();
    return Container(
      color: Colors.yellow.shade600,
      alignment: Alignment.center,
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Total Price: $_totalPrice",
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            child: const Text(
              'Proceed to Pay',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              if (!_isUserLoggedIn) {
                context.pushNamed(PageNames.login);
              }

              
              
            },
          )
        ],
      ),
    );
  }
}
