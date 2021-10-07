import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart' as screen;

class OrderScreen extends StatelessWidget {
  static const routeName = "/orders";
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(title: Text("Your Orders")),
        drawer: AppDrawer(),
        body: ListView.builder(
            itemCount: orderData.orders.length,
            itemBuilder: (ctx, i) => screen.OrderItem(
                  order: orderData.orders[i],
                )));
  }
}
