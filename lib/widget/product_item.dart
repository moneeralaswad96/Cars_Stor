import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_firebase/provider/auth.dart';
import 'package:shop_firebase/provider/product.dart';
import '../screen/product_detail_screen.dart';
import '../provider/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: true);
    final authData = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      
      borderRadius: BorderRadius.circular(12),
      child: GridTile(

        footer: GridTileBar(

          backgroundColor: Colors.pink[75],
          title: Container(
            decoration:BoxDecoration(
              borderRadius:BorderRadius.circular(25),
              color: Colors.black38
            ),
            child: Text(
              product.title,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
          ),
          leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                    color: Colors.pink[200],
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    onPressed: () {
                      product.toggleFavoriteStatus(
                          authData.token, authData.userId);
                    },
                  )),
          trailing: IconButton(disabledColor: Colors.black12,
            highlightColor: Colors.black,
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('تمت الاصافة الى الطلبات'),
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  textColor: Colors.red,
                    label: "تراجع عن الطلب ",
                    onPressed: () {
                      cart.removeSingleIrem(product.id);
                    }),
              ));
            },
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.pink[200],
            ),
          ),
        ),
        child: GestureDetector(
          child: Hero(
            child: FadeInImage(
              image: NetworkImage(product.imageUrl),
              placeholder: AssetImage("assets/images/3.jpg"),
              fit: BoxFit.cover,
            ),
            tag: product.id,
          ),
          onLongPress: () {},
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScareen.routeName, arguments: product.id),
        ),
      ),
    );
  }
}
