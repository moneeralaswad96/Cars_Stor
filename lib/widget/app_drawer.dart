import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen/orders_screen.dart';
import '../provider/auth.dart';
import '../screen/user_products_screen.dart';
import '../screen/product_overview_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

class App_Drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: Text('AccountName'),
              accountEmail: Text(
                Provider.of<Auth>(context, listen: false).authData['email'],
              )),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductOverScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed(OrderScreen.routeName);
            },
          ),
          Provider.of<Auth>(context).token!=null
              ? Column(
                  children: [
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Manage Products'),
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(UserPeoductsScreen.routeName);
                      },
                    ),
                  ],
                )
              : SizedBox(),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed(UserPeoductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('LogOut'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logOut();
              toast("تم تسجيل الخروج");
            },
          ),
        ],
      ),
    );
  }
}
