import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart' as screen;

class OrderScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context).fetchOrders();
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(title: Text("Your Orders")),
        drawer: AppDrawer(),
        body: _isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, i) => screen.OrderItem(
                      order: orderData.orders[i],
                    )));
  }
}
