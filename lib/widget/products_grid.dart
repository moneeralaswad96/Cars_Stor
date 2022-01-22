import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_firebase/provider/products.dart';
import 'package:shop_firebase/widget/product_item.dart';

import '../constants.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorite;

  const ProductsGrid({this.showFavorite});
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context,listen: false);

    final  products =
        showFavorite ? productData.favoritesItems : productData.items;
    return GridView.builder(
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: kDefaultPaddin,
        crossAxisSpacing: kDefaultPaddin,
        childAspectRatio: 0.75,
      ),
    );
  }
}
