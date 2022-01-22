import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final int quantity;
  final String title;
  final double price;

  CartItem({
    @required this.id,
    @required this.quantity,
    @required this.title,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> items = {};

  // Map<String, CartItem> get items {
  //   return {..._items};
  // }

  int get itemCount {
    return items.length;
  }

  double get totlaAmount {
    double total = 0.0;

    items.forEach((key, CartItem) {
      total += CartItem.price * CartItem.quantity;
    });

    return total;
  }

  void addItem(String productId, double price, String title) {
    if (items.containsKey(productId)) {
      items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            quantity: existingCartItem.quantity + 1,
            title: existingCartItem.title,
            price: existingCartItem.price),
      );
    } else {
      items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toIso8601String(),
            quantity: 1,
            title: title,
            price: price),
      );
    }
    notifyListeners();
  }

  void removeIrem(String productId) {
    items.remove(productId);
    notifyListeners();
  }

  void removeSingleIrem(String productId) {
    if (!items.containsKey(productId)) {
      return;
    }
    if(items[productId].quantity>1){
       items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            quantity: existingCartItem.quantity - 1,
            title: existingCartItem.title,
            price: existingCartItem.price),
      );
    }else{
      items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    items = {};
    notifyListeners();
  }
}
