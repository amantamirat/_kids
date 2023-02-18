import 'package:abdu_kids/model/user.dart';
import 'package:abdu_kids/model/util/cart_item.dart';
import 'package:abdu_kids/services/user_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:abdu_kids/services/database_util.dart';
import 'package:abdu_kids/util/extra_wrapper.dart';
import 'package:abdu_kids/util/page_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  late num _totalPrice;
  late bool _isUserLoggedIn;
  Future<String>? _placeOrderMessage;
  @override
  void initState() {
    super.initState();
    _totalPrice = 0;
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
              if (snapshot.hasData) {                
                _updateTotalPrice(snapshot.data!);
              }

              return Scaffold(
                  appBar: AppBar(
                    title:
                        Text("My Cart ${_isUserLoggedIn ? '- ON' : '- OFF'}"),
                  ),
                  body: snapshot.hasData
                      ? _displayList(snapshot.data!)
                      : Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Center(child: Text('Empty Cart!'))),
                  bottomNavigationBar:
                      snapshot.hasData ? _summry(snapshot.data!) : Container());
            }
        }
      },
    );
  }

  void _updateTotalPrice(List<CartItem> myList) {
    _totalPrice = 0;
    for (int i = 0; i < myList.length; i++) {
      final item = myList.elementAt(i);
      if (item.selectedKind != null) {
        _totalPrice =
            _totalPrice + item.quantity * item.selectedKind!.product!.price;
      }
    }
  }

  Widget _displayList(List<CartItem> myList) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: myList.length,
        itemBuilder: (BuildContext context, int index) {
          final item = myList.elementAt(index);
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
                imageUrl: Constants.getImageURL(item.kindId),
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
                context.pushNamed(PageNames.viewKinds,
                    extra:
                        ExtraWrapper(widget.loggedInUser, item.selectedKind));
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
                      int result = await CartDataBase.deleteItem(item);
                      if (result == 1) {
                        setState(() {
                          _totalPrice = _totalPrice - price;
                          myList.remove(item);
                        });
                      }
                      return;
                    }
                    item.quantity = value.toInt();
                    await CartDataBase.updateCartItem(item);
                    setState(() {
                      _totalPrice = _totalPrice - price + value.toInt();
                    });
                  },
                ),
              ),
            ),
          );
        });
  }

  Widget _summry(List<CartItem> myList) {
    return Container(
      color: Colors.yellow.shade600,
      alignment: Alignment.center,
      height: 60.0,
      child: Column(
        children: [
          FutureBuilder(
            future: _placeOrderMessage,
            builder: (
              BuildContext context,
              AsyncSnapshot<String?> snapshot,
            ) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!,
                          style: const TextStyle(color: Colors.red));
                    }
                    return Container();
                  }
              }
            },
          ),
          Row(
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
                  if (myList.isEmpty) {
                    return;
                  }
                  if (!_isUserLoggedIn) {
                    GoRouter.of(context).pushNamed(PageNames.login);
                    return;
                  }
                  setState(() {
                    _placeOrderMessage =
                        UserService.placeOrders(widget.loggedInUser!, myList);
                  });
                  //add to local ordered database,
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
