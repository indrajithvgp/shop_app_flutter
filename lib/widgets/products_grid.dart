import "package:flutter/material.dart";
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  // const ProductsGrid({
  //   Key key,
  //   @required this.loadedProducts,
  // }) : super(key: key);

  // final List<Product> loadedProducts;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductItem(
          products[i].id,
          products[i].title, products[i].imageUrl),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.5,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          crossAxisSpacing: 10),
    );
  }
}
