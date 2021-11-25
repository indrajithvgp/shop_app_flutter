import 'package:flutter/material.dart';
import 'package:shop_app/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen();

  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    final product =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 130,
              pinned:true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(product.title),
                background: Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10),
                  Text('\$${product.price}',
                      style: TextStyle(color: Colors.grey, fontSize: 20)),
                  SizedBox(height: 10),
                  Container(  
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Text('${product.description}',
                        textAlign: TextAlign.center, softWrap: true),
                  ),
                  SizedBox(height: 800),
                ],
              ),
            )
          ],
        ));
  }
}
