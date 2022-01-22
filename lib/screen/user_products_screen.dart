import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_firebase/widget/app_drawer.dart';

import '../widget/user_products_items.dart';

import '../provider/products.dart';
import '../screen/edit_product_screen.dart';

class UserPeoductsScreen extends StatelessWidget {
  static const routeName = "/UserPeoductsScreen ";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your products"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName))
        ],
      ),
      drawer: Drawer(child: App_Drawer()),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, index) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                UserProductItem(
                                    productData.items[index].id,
                                    productData.items[index].title,
                                    productData.items[index].imageUrl),
                                Divider(),
                              ],
                            ),
                          ),
                          itemCount: productData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
