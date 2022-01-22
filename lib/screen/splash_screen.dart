import 'package:flutter/material.dart';
// import 'package:shop_firebase/screen/auth_screen.dart';
import 'package:shop_firebase/screen/product_overview_screen.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash_Screen extends StatelessWidget {
  static const routeName = "/SplashScreen ";

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds:ProductOverScreen(),
      title: new Text('Online Store',
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30.0
      ),),
      image: new Image.asset('assets/images/4.png',),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      
      loaderColor: Colors.black38
    );
  }
}

