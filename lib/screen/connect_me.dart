import 'package:flutter/material.dart';

class connect extends StatefulWidget {
  @override
  _connectState createState() => _connectState();
}

class _connectState extends State<connect> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "\nتواصل معنا \n+9#### ",textAlign:TextAlign.center ,
          style: TextStyle(
              color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
