import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/model/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  // var _showFavoritesOnly = false;
  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showFavoritesAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchProducts() async {
    var url = Uri.parse(
        "https://flutter-app-b86f6-default-rtdb.firebaseio.com/products.json");
    try {
      final response = await http.get(url);
      var extractedResponse = await response.body as Map<String, dynamic>;
      List<Product> _loadedProducts = [];
      extractedResponse.forEach((key, value) {
        _loadedProducts.add(Product(
            description: value.description,
            title: value.title,
            imageUrl: value.imageUrl,
            price: value.price,
            isFavorite: value.isFavorite,
            id: key));
      });
      _items = _loadedProducts;
      notifyListeners();
    } catch (err) {}
  }

  Future<void> addProduct(Product value) async {
    var url = Uri.parse(
        "https://flutter-app-b86f6-default-rtdb.firebaseio.com/products.json");
    try {
      var response = await http.post(url,
          body: json.encode({
            "description": value.description,
            "title": value.title,
            "price": value.price,
            "isFavorite": value.isFavorite,
            "imageUrl": value.imageUrl,
          }));

      final product = Product(
        description: value.description,
        title: value.title,
        price: value.price,
        id: json.decode(response.body),
        imageUrl: value.imageUrl,
      );
      _items.add(product);
      notifyListeners();
      return;
    } catch (error) {
      print(error);
    }
    // return http
    //     .post(url,
    //         body: json.encode({
    //           "description": value.description,
    //           "title": value.title,
    //           "price": value.price,
    //           "isFavorite": value.isFavorite,
    //           "imageUrl": value.imageUrl,
    //         }))
    //     .then((response) {
    //   final product = Product(
    //     description: value.description,
    //     title: value.title,
    //     price: value.price,
    //     id: json.decode(response.body),
    //     imageUrl: value.imageUrl,
    //   );
    //   _items.add(product);
    //   notifyListeners();
    //   return;
    // });
  }

  void updateProduct(String id, Product product) {
    final _id = _items.indexWhere((item) => item.id == id);
    if (_id >= 0) {
      final url =
          "https://flutter-app-b86f6-default-rtdb.firebaseio.com/products/$id.json";
      try {
        http.patch(Uri.parse(url),
            body: json.encode({
              "description": product.description,
              "title": product.title,
              "price": product.price,
              // "isFavorite": product.isFavorite,
              "imageUrl": product.imageUrl,
            }));
      } catch (err) {}
    }
    _items[_id] = product;
    notifyListeners();
  }

  void removeProduct(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Product findById(id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void deleteProduct(String id) {
    final _id = _items.indexWhere((item) => item.id == id);
    var _product = _items[_id];
    _items.removeAt(_id);
    final url =
        "https://flutter-app-b86f6-default-rtdb.firebaseio.com/products/$id.json";
    try {
      final response = http.delete(Uri.parse(url));
      if (response.statusCode >= 400) {
        _items.insert(_id, _product);
        notifyListeners();
        throw HttpException("Deletion Failed");
      }
      _product = null;
    } catch (err) {
      _items.insert(_id, _product);
    }
    notifyListeners();
  }
}
