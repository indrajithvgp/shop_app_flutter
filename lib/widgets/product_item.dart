import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
          child: GestureDetector(
              onTap: () {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (ctx) => ProductDetailScreen()));
                Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                    arguments: product.id);
              },
              child: Image.network(product.imageUrl, fit: BoxFit.cover)),
          footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Consumer<Product>(
                builder: (ctx, product, child) => IconButton(
                    icon: Icon(product.isFavorite
                        ? Icons.check_box
                        : Icons.favorite_border),
                    onPressed: () {
                      product.toggleFavoriteStatus();
                    },
                    color: Theme.of(context).accentColor),
              ),
              trailing: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    cart.addItem(product.id, product.price, product.title);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Item added to cart'),
                        action: SnackBarAction(
                            label: "UNDO",
                            onPressed: () {
                              cart.removeSingleItem(product.id);
                            }),
                        duration: Duration(seconds: 2)));
                  },
                  color: Theme.of(context).accentColor),
              title: Text(product.title, textAlign: TextAlign.center))),
    );
  }
}
