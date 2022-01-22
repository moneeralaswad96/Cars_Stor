import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../screen/auth_screen.dart';

class Product with ChangeNotifier {
      final String id;
  
      final String description;
      final String title;
      final double price;
      final String imageUrl;
      bool isFavorite;

      Product({
        @required this.id,
        @required this.description,
        @required this.title,
        @required this.price,
        @required this.imageUrl,
        this.isFavorite = false,
      });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        "https://shop-firebase-b910f-default-rtdb.firebaseio.com/userFavorites/$title.json";

    try {
      final res = await http.put(url, body: json.encode((isFavorite)));
      if (res.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (e) {
       
      _setFavValue(oldStatus);
    }
  }
}
