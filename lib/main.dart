//  import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shop_firebase/screen/splash_screen.dart';
// import 'package:shop_firebase/screen/splash_screen.dart';
import 'package:shop_firebase/screen/user_products_screen.dart';

import './provider/cart.dart';
import './provider/orders.dart';
import './screen/auth_screen.dart';
import './screen/edit_product_screen.dart';
import './screen/orders_screen.dart';
import './screen/product_detail_screen.dart';
import './screen/product_overview_screen.dart';
// import './screen/splash_screen.dart';
import './screen/cart_screen.dart';
import 'constants.dart';
import 'provider/auth.dart';
import 'provider/products.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'provider/product.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.reference();

  runApp(myApp());
}

class myApp extends StatefulWidget {
  const myApp({Key key}) : super(key: key);

  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (ctx, authValue, previousProducts) => previousProducts
            ..getData(authValue.token, authValue.userId,
                previousProducts == null ? null : previousProducts.items),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (ctx, authValue, previousOrders) => previousOrders
            ..getData(authValue.token, authValue.userId,
                previousOrders == null ? null : previousOrders.orders),
        ),
        ChangeNotifierProvider.value(value: Orders()),
        ChangeNotifierProvider.value(value: Cart()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
            primaryColor: kTextLightColor,
            accentColor: Colors.black38,
            backgroundColor: Colors.teal[50],
            fontFamily: "Lato",
           
          ),
          home: auth.token != null
              ? Splash_Screen()
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, AsyncSnapshot snap) =>
                      snap.hasData ? Splash_Screen(): AuthScreen()),

          //  FutureBuilder(
          //     future: auth.tryAutoLogIn(),
          //     builder: (ctx, snapshot) =>
          //         snapshot.connectionState == ConnectionState.waiting
          //             ? SplashScreen()
          //             : AuthScreen()),
          routes: {
            ProductDetailScareen.routeName: (_) => ProductDetailScareen(),
            CartScreen.routeName: (_) => CartScreen(),
            AuthScreen.routeName: (_) => AuthScreen(),
            OrderScreen.routeName: (_) => OrderScreen(),
            UserPeoductsScreen.routeName: (_) => UserPeoductsScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
            ProductOverScreen.routeName: (_) => ProductOverScreen(),
          },
        ),
      ),
    );
  }
}
