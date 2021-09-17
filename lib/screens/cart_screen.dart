import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
        appBar: AppBar(title: Text("Your Cart")),
        body: Column(
          children: [
            Card(
                margin: EdgeInsets.all(15),
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Your Total', style: TextStyle(fontSize: 20)),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Spacer(),
                          Chip(
                            label: Text(
                              '\$${cart.totalAmount.toString()}',
                              style: TextStyle(color: Colors.purple),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          FlatButton(
                              onPressed: () {
                                Provider.of<Orders>(context, listen: false).addOrder(
                                    cart.items.values.toList(),
                                    cart.totalAmount);

                                cart.clear();
                              },
                              child: Text('Order Now'),
                              textColor: Theme.of(context).primaryColor)
                        ]))),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      return ci.CartItem(
                          id: cart.items.values.toList()[i].id,
                          price: cart.items.values.toList()[i].price,
                          quantity: cart.items.values.toList()[i].quantity,
                          productId: cart.items.keys.toList()[i],
                          title: cart.items.values.toList()[i].title);
                    }))
          ],
        ));
  }
}

// cart.items.values.toList()[i].quantity
