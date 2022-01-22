import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_firebase/widget/order_item.dart';

import '../widget/app_drawer.dart';
import '../provider/orders.dart' show Orders;

class OrderScreen extends StatelessWidget {
  static const routeName = "/OrderScreen ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Oredes"),
      // ),
      drawer: Drawer(child: App_Drawer()),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(child: Text("error "));
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, chlid) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, index) => orderData.orders.length>0
                      ? Orderitem(orderData.orders[index])
                      : Center(
                          child: Text(
                            "لايوجد طلبات",
                            style: TextStyle(color:Colors.black),
                            textAlign: TextAlign.center,

                          ),
                        ),
                ),
              );
            }
          }
        },
        future: Provider.of<Orders>(context, listen: false).fecthAndSetOrders(),
      ),
    );
  }
}
