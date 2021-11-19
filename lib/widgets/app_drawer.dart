import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Drawer(
        child: Column(children: [
      AppBar(title: Text("Hello friend")),
      Divider(),
      ListTile(
          leading: Icon(Icons.shop),
          title: Text("Shop"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed("/");
          }),
      Divider(),
      ListTile(
          leading: Icon(Icons.payment),
          title: Text("Orders"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
          }),
          Divider(),
      ListTile(
          leading: Icon(Icons.shop),
          title: Text("Manage Products"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
          }),
          Divider(),
          ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Log Out"),
          onTap: () {
            Navigator.of(context)
                .pop();
              auth.logOut();
          })
    ]));
  }
}
