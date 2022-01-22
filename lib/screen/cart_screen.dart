import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_firebase/widget/app_drawer.dart';

import '../provider/cart.dart' show Cart;

import '../provider/orders.dart';
import '../widget/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/CartScreen ";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cart = Provider.of<Cart>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      drawer: Drawer(child: App_Drawer()),
      body: Container(
        height: size.height * 0.9,
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("totla", style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Chip(
                      elevation: 5,
                      labelPadding: EdgeInsets.all(5),
                      backgroundColor: Colors.black26,
                      label: Text("\$${cart.totlaAmount.toStringAsFixed(2)}"),
                    )
                    // OrderButton(cart:),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) => CartItem(
                cart.items.values.toList()[index].id,
                cart.items.keys.toList()[index],
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].quantity,
                cart.items.values.toList()[index].title,
              ),
            )),
            Positioned(
              width: double.infinity,
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: OrderBotton(
                    cart: cart,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class OrderBotton extends StatefulWidget {
  final Cart cart;

  const OrderBotton({this.cart});

  @override
  _OrderBottonState createState() => _OrderBottonState();
}

class _OrderBottonState extends State<OrderBotton> {
  void showErrorDailog(String message) => showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("oK"))
            ],
            content: Text(message),
            title: Text("welcome"),
          ));
  var _isloading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isloading
          ? CircularProgressIndicator()
          : Text(
              "Order Now",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
      onPressed: (widget.cart.totlaAmount <= 0 || _isloading)
          ? null
          : () async {
              setState(() {
                _isloading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totlaAmount);
              setState(() {
                _isloading = false;
              });
              widget.cart.clear();
              showErrorDailog(" تم ارسال طلبك ");
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
