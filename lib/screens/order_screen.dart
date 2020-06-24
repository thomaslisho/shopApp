import 'package:flutter/material.dart';
import 'package:myShop/widgets/app_drawer.dart';

import 'package:provider/provider.dart';

import '../widgets/order_item.dart';
import '../providers/orders.dart' hide OrderItem;

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: orderData.orders.isEmpty
          ? Center(
              child: Text(
                'Order Something',
              ),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) => OrderItem(orderData.orders[index]),
              itemCount: orderData.orders.length,
            ),
      drawer: AppDrawer(),
    );
  }
}
