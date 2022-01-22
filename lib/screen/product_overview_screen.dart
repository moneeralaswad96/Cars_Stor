import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_firebase/provider/cart.dart';
import 'package:shop_firebase/provider/products.dart';
import 'package:shop_firebase/screen/cart_screen.dart';
import 'package:shop_firebase/screen/connect_me.dart';
import 'package:shop_firebase/screen/orders_screen.dart';
import 'package:shop_firebase/widget/app_drawer.dart';
import 'package:shop_firebase/widget/badge.dart';
import 'package:shop_firebase/widget/products_grid.dart';
import 'package:shop_firebase/widget/search.dart';

import 'package:shop_firebase/constants.dart';

enum FilterOption { Favorites, All }
 var showOnlyFavorites = false;
class ProductOverScreen extends StatefulWidget {


    

  static const routeName = "/ProductOverScreen";

  @override
  _ProductOverScreenState createState() => _ProductOverScreenState();
}



class _ProductOverScreenState extends State<ProductOverScreen> {

 
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }


   List<Map<String, Object>>   pages = [
      {
        'page':gridView() ,
        'title': Text("STORE"),
      },
      {
        'page': OrderScreen(),
        'title': Text("Orders"),
      },
      {
        'page': connect(),
        'title':Text("تواصل معنا"),
      },
     
    ];






  
  var _isloading = false;
  
  @override
  void initState() {
    super.initState();

    _isloading = true;
    Provider.of<Products>(context, listen: false)
        .fetchData()
        .then((_) => setState(() {
              _isloading = false;
            }))
        .catchError((_) {
      setState(() {
        _isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {



   
    return Scaffold(
      drawer: Drawer(child: App_Drawer()),
      appBar: AppBar(
        title: pages[_selectedPageIndex]['title'],
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: Search());
              }),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(value: cart.itemCount.toString(), child: ch),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                size: 30,
              ),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ),
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("favorites"),
                      value: FilterOption.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text("All Products"),
                      value: FilterOption.All,
                    ),
                  ],
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOption selectedVal) {
                setState(() {
                  if (selectedVal == FilterOption.Favorites) {
                    showOnlyFavorites = true;
                  } else {
                    showOnlyFavorites = false;
                  }
                });
              }),
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          :pages[_selectedPageIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
         showSelectedLabels: true,

          elevation: 5,
          type:BottomNavigationBarType.fixed ,
          onTap: _selectPage,
          backgroundColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.white,
          selectedItemColor: Theme.of(context).canvasColor,
          currentIndex: _selectedPageIndex,
          // type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.shop),
              title: Text("المتجر"),
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.payment),
              title: Text("الطلبات"),
            ),
            
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.call,),
              title: Text("تواصل معنا"),
            ),
          ],
        ), 
          
          
          
         
    );
  }
}

class gridView extends StatefulWidget {
  
  @override
  _gridViewState createState() => _gridViewState();
}
 Future<void> _refreshProducts(BuildContext context) async {
      await Provider.of<Products>(context, listen: false)
          .fetchData();
    }


class _gridViewState extends State<gridView> {
 
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductsGrid(showFavorite: showOnlyFavorites),
              ),
            );
  }
}