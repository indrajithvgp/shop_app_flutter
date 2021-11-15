import "package:flutter/material.dart";
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:shop_app/widgets/products_grid.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorites, All }

class ProductOverview extends StatefulWidget {
  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _init = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState(); 
    // Future.delayed(Duration(microseconds: 2), () async {
    //   try {
    //     await Provider.of<Products>(context).fetchProducts();
    //   } catch (err) {}
    // });
  }

  void didChangeDependencies() async {
    super.didChangeDependencies();
    setState(() {
      _isLoading = true;
    });
    if (_init) {
      try {
        await Provider.of<Products>(context).fetchProducts();
        setState(() {
          _isLoading = false;
        });
      } catch (err) {}
    }
    setState(() {
      _isLoading = false;
      _init = false;
    });
  }

  bool _showFavoritesOnly = false;
  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text("My App"),
          actions: <Widget>[
            PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => [
                      PopupMenuItem(
                          child: Text('Only Favorites'),
                          value: FilterOptions.Favorites),
                      PopupMenuItem(
                          child: Text('All'), value: FilterOptions.All)
                    ],
                onSelected: (FilterOptions selectedValue) => {
                      setState(() {
                        if (selectedValue == FilterOptions.Favorites) {
                          _showFavoritesOnly = true;
                        } else {
                          _showFavoritesOnly = false;
                        }
                      })
                    }),
            Consumer<Cart>(
                builder: (_, cart, ch) => Badge(
                      child: ch,
                      value: cart.itemCount.toString(),
                    ),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                    icon: Icon(Icons.shopping_cart)))
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ProductsGrid(_showFavoritesOnly));
  }
}
