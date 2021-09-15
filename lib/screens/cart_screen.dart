import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
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
                              onPressed: () {},
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
                      return ci.CartItem(cart.items[i].id, cart.items[i].price,
                          cart.items[i].quantity, cart.items[i].title);
                    }))
          ],
        ));
  }
}

// cart.items.values.toList()[i].quantity
