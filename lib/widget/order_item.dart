import 'package:flutter/material.dart';

import '../provider/orders.dart' as or;
import 'dart:math';

class Orderitem extends StatelessWidget {
  final or.OrderItem order;

  const Orderitem(this.order);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
            title: Text("\$ ${order.amount} السعر النهائي"),
            subtitle: Text("${DateTime.now()}"),
            children: order.products
                .map(
                  (prod) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        prod.title+"/النوع",
                        style: TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.white10,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' quantity= ${prod.quantity}',
                        style: TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.white10,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' price= ${prod.price}',
                        style: TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.white10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
                .toList()));
  }
}
