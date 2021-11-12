import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class Product with ChangeNotifier {
  final String id;
  final String description;
  final String title;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.description,
      @required this.title,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus() async {
    var oldValue = isFavorite;
    isFavorite = !isFavorite;
    final url =
        "https://flutter-app-b86f6-default-rtdb.firebaseio.com/products/$id.json";
    try {
      final response = await http.patch(Uri.parse(url), body: json.encode({
        "isFavorite": isFavorite
      }));
      if (response.statusCode >= 400) { 
        isFavorite = oldValue;
        notifyListeners();
      }
    } catch (err) {
      isFavorite = oldValue;
      notifyListeners();
    }
    notifyListeners();
  }
}
