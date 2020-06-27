import 'package:flutter/material.dart';
import 'package:myShop/widgets/app_drawer.dart';

import 'package:provider/provider.dart';

import '../widgets/order_item.dart';
import '../providers/orders.dart' hide OrderItem;

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            if (snapshot.error != null)
              return Center(
                child: Text('An Error Occured'),
              );
            else
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemBuilder: (ctx, index) =>
                      OrderItem(orderData.orders[index]),
                  itemCount: orderData.orders.length,
                ),
              );
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
