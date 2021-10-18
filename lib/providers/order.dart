import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:shop_app/widgets/cart_item.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.dateTime,
      @required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  // void addOrder(List<CartItem> cartProducts, double total) {
  //   _orders.insert(
  //       0,
  //       OrderItem(
  //         id: DateTime.now().toString(),
  //         dateTime: DateTime.now(),
  //         amount: total,
  //         products: cartProducts
  //       ));
  // }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://flutter-app-b86f6-default-rtdb.firebaseio.com/orders.json";
    final timeStamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          "productId": cartProducts
              .map((e) => ({
                    'id': e.id,
                    'quantity': e.quantity,
                    "price": e.price,
                    "title": e.title,
                  }))
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            dateTime: timeStamp,
            amount: total,
            products: cartProducts));
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url =
        "https://flutter-app-b86f6-default-rtdb.firebaseio.com/orders.json";

    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedResponse =
        json.decode(response.body) as Map<String, dynamic>;
    if (extractedResponse == null) {
      return;
    }
    extractedResponse.forEach((key, value) {
      loadedOrders.add(OrderItem(
          id: key,
          amount: value["amount"],
          dateTime: DateTime.parse(value['dateTime']),
          products: (value['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item.id,
                  title: item.title,
                  price: item.price,
                  quantity: item.quantity))
              .toList()));
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
