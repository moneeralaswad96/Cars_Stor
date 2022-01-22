import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_firebase/provider/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> orders = [];
  String authToken;
  String userId;

  getData(String authTok, String uId, List<OrderItem> orders) {
    authToken = authTok;
    userId = uId;
    orders = orders;
    notifyListeners();
  }

  // List<OrderItem> get orders {
  //   return [..._orders];
  // }

  Future<void> fecthAndSetOrders() async {
    var url =
        "https://shop-firebase-b910f-default-rtdb.firebaseio.com/orders.json";

    try {
      final res = await http.get(url);
      final extractData = json.decode(res.body) as Map<String, dynamic>;
      if (extractData == null) return;

      final List<OrderItem> loadedOrders = [];
      extractData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  quantity: item['quantity'],
                  title: item['title'],
                  price: item['price']))
              .toList(),
        ));
      });

      orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    var url =
        "https://shop-firebase-b910f-default-rtdb.firebaseio.com/orders.json";

    try {
      // final timestamp=DateTime.now();
      var res = await http.post(url,
          body: json.encode({
            "amount": total,
            // "dateTime": timestamp,
            "products": cartProduct
                .map((cartPro) => {
                      'id': cartPro.id,
                      'title': cartPro.title,
                      'quantity': cartPro.quantity,
                      'price': cartPro.price,
                    })
                .toList(),
          }));
      orders.insert(
          0,
          OrderItem(
            id: json.decode(res.body)['name'],
            amount: total,
            products: cartProduct,
          ));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
  // L

}
