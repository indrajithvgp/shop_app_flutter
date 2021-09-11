import "package:flutter/material.dart";
import 'package:shop_app/widgets/product_item.dart';
import 'package:shop_app/widgets/products_grid.dart';
import '../model/product.dart';

class ProductOverview extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("My App"),
        // ),
        body: ProductsGrid());
  }
}

