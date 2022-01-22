import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_firebase/provider/products.dart';
import 'package:shop_firebase/widget/app_drawer.dart';
// import '../provider/cart.dart';
// import '../provider/Product.dart';

class ProductDetailScareen extends StatelessWidget {
  static const routeName = "/ProductDetailScreen ";

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Product>(context, listen: true);

    // final cart = Provider.of<Cart>(context, listen: false);
     final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      drawer: App_Drawer(),
      //  appBar: AppBar(title:Text(loadedProduct.title,)),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
             
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Center(
                  child: Text(loadedProduct.title,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
                background: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "\$ ${loadedProduct.price}",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(fontSize: 25),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                ),
                SizedBox(
                  height: 300,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
