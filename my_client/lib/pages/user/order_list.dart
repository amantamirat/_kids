import 'package:abdu_kids/model/util/order.dart';
import 'package:abdu_kids/model/util/ordered_item.dart';
import 'package:abdu_kids/services/user_service.dart';
import 'package:abdu_kids/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:abdu_kids/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyOrderList extends StatefulWidget {
  final User loggedInUser;
  const MyOrderList({Key? key, required this.loggedInUser}) : super(key: key);
  @override
  State<MyOrderList> createState() => _MyOrderList();
}

class _MyOrderList extends State<MyOrderList> {
  late Future<List<Order>?> _myFuture;
  @override
  void initState() {
    super.initState();
    _myFuture = UserService.findOrders(widget.loggedInUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.loggedInUser.email} Orders")),
      body: FutureBuilder(
        future: _myFuture,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Order>?> snapshot,
        ) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${snapshot.error}'),
                    ],
                  ),
                );
              } else {
                return snapshot.data!.isEmpty
                    ? const Center(child: Text("No Orders Found"))
                    : OrderList(orders: snapshot.data!);
              }
          }
        },
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final List<Order>? orders;
  const OrderList({super.key, this.orders});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      itemCount: orders!.length,
      itemBuilder: (BuildContext context, int index) {
        final order = orders!.elementAt(index);
        return _buildExpandableTile(order);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _buildExpandableTile(Order order) {
    return ExpansionTile(
      title: Text("Ordered Date: ${order.date!}",
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent)),
      subtitle: Text(
          "Total Quantity: ${order.totalQuantity!} Total Amount: ${order.totalPrice!}",
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w200, color: Colors.black)),
      children:
          order.orderedItems!.map<Widget>((item) => _showItem(item)).toList(),
    );
  }

  Widget _showItem(OrderedItem item) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: Constants.getImageURL(item.kindId),
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
      title: Text(
        "${item.brand} ${item.productDetail} - ${item.productSize} ${item.productColor} ",
        style: const TextStyle(fontWeight: FontWeight.w100),
      ),
      subtitle:
          Text("Quantity ${item.quantity}, Item Price ${item.productPrice}"),
    );
  }
}
