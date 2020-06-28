import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as OrderMain;

class OrderItem extends StatefulWidget {
  final OrderMain.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
      height:
          _expanded ? min(widget.order.products.length * 25.0 + 120, 250) : 95,
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(Icons.expand_more),
            ),
          ),
          Divider(),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: _expanded
                ? min(widget.order.products.length * 21.0 + 25, 180)
                : 0,
            child: ListView(
              children: widget.order.products
                  .map((e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            e.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${e.quantity} X \$${e.price}',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
