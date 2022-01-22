

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;

  final String title;

  const CartItem(
      this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (dir){
        Provider.of<Cart>(context,listen: false).removeIrem(productId);
      },
      confirmDismiss: (dir){
        return showDialog(
          context: context,
        builder:(ctx)=>
        AlertDialog(
          actions: [
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("!No")),
             FlatButton(onPressed: (){
              Navigator.of(context).pop(true);
            }, child: Text("Yes")),
          ],title: Text('Are you sure?'),
        content: Text("هل تريد حذف العنصر بالتأكيد ؟"),));
      },
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.delete,
          size: 35,
          color: Colors.red[100],
        ),
      ),
      key: ValueKey(id),
      child: Card(
        margin: EdgeInsets.all(15),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            title: Text(title),
            subtitle: Text('total \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$ $price'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
