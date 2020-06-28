import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:myShop/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String _authToken;
  final String _userId;
  static const _url = 'https://my-shop-flutter-project.firebaseio.com/orders/';

  Orders(this._authToken, this._userId, this._orders);

  List<OrderItem> get orders => [..._orders];

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = '$_url$_userId.json?auth=$_authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map(
                (e) => {
                  'id': e.id,
                  'title': e.title,
                  'quantity': e.quantity,
                  'price': e.price,
                },
              )
              .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }

  int get orderLength => _orders.length;

  Future<void> fetchAndSetOrders() async {
    final url = '$_url$_userId.json?auth=$_authToken';
    final List<OrderItem> loadedList = [];
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach(
      (orderId, orderData) {
        loadedList.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['id'],
                  quantity: e['quantity'],
                  price: e['price'],
                  title: e['title'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ));
      },
    );
    _orders = loadedList;
    notifyListeners();
  }
}
