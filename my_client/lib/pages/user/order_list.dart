import 'package:abdu_kids/model/util/order.dart';
import 'package:flutter/material.dart';
import 'package:abdu_kids/model/user.dart';

class OrderList extends StatefulWidget {
  final User selectedUser;
  const OrderList({Key? key, required this.selectedUser}) : super(key: key);
  @override
  State<OrderList> createState() => _OrderList();
}

class _OrderList extends State<OrderList> {
  late List<Order>? orders;
  @override
  void initState() {
    super.initState();
    orders = widget.selectedUser.orders;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
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
      title: Text(
        order.date!,
      ),
      children: <Widget>[
        ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: order.orderedItems!.length,
          itemBuilder: (BuildContext context, int index) {
            final item = order.orderedItems!.elementAt(index);
            return ListTile(
              title: Text(
                "${item.brand} ${item.productDetail} ",
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        )
      ],
    );
  }
}
