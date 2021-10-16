import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-product-screen";

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Products"),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                })
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () {
            refreshProducts(context);
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
                itemBuilder: (ctx, i) => Column(
                      children: [
                        UserProductItem(
                            productsData.items[i].id,
                            productsData.items[i].title,
                            productsData.items[i].imageUrl),
                        Divider(),
                      ],
                    ),
                itemCount: productsData.items.length),
          ),
        ));
  }
}
