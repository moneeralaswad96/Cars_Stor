import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop_firebase/screen/product_overview_screen.dart';

// import 'package:shop_app_firebase/models/http_expestion.dart';
import '../provider/auth.dart';
import '../models/http_expestion.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../screen/product_overview_screen.dart';
import 'package:shop_firebase/constants.dart';

var isloading = false;

class AuthScreen extends StatefulWidget {
  static const routeName = "/AuthScreen ";
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
      lowerBound: 0.3,
      upperBound: 0.9,
    )..repeat(period: Duration(seconds: 6), reverse: true);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var google = Provider.of<Auth>(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      // key:_scaffoldKey ,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "المتجر الالكتروني",
                softWrap: true,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: deviceSize.width,
              height: deviceSize.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      stops: [0, 1],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: [
                        kTextLightColor.withOpacity(0.3),
                        Colors.white38,
                      ])),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScaleTransition(
                    scale: _animation,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: Container(
                        width: deviceSize.width * 0.90,
                        height: deviceSize.height * 0.4,
                        child: Image.asset('assets/images/2.jpg',
                            fit: BoxFit.fill),
                      ),
                    )),

                Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1, child: AuthCard()),

                // isloading
                //     ? Center(child: CircularProgressIndicator())
                //     : Center(
                //         child: Container(
                //             width: deviceSize.width * 0.85,
                //             child: FlatButton.icon(
                //                 shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(10)),
                //                 padding: EdgeInsets.all(10),
                //                 color: Colors.white,
                //                 onPressed: () async {
                //                   setState(() {
                //                     isloading = true;
                //                   });

                //                   try {
                //                     var user = await google.signInWithGoogle();
                //                   } catch (error) {
                //                     print(error);
                //                   }

                //                   Builder(builder: (ctx) {
                //                     Navigator.of(ctx).popAndPushNamed(
                //                         ProductOverScreen.routeName);
                //                   });
                //                 },
                //                 icon: Icon(Icons.login),
                //                 label: Text("LogIn-with google"))),
                //       ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { logIn, singUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final passwordcontroller = TextEditingController();

  final GlobalKey<FormState> _formKay = GlobalKey();
  AuthMode _authMode = AuthMode.logIn;

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<Offset> _opacityAnimation;

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

  void showErrorDailog(String message) => showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("oK"))
            ],
            content: Text(message),
            title: Text(" An error"),
          ));

  void switchAuthMode() {
    if (_authMode == AuthMode.logIn) {
      setState(() {
        _authMode = AuthMode.singUp;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.logIn;
      });
      _controller.reverse();
    }
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(microseconds: 400));
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.15), end: Offset(0, 0))
        .animate(
            CurvedAnimation(curve: Curves.fastOutSlowIn, parent: _controller));

    _opacityAnimation = Tween<Offset>(
      begin: Offset(0, -0.15),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(curve: Curves.easeIn, parent: _controller));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKay.currentState.validate()) {
      return;
    } else {
      _formKay.currentState.save();
    }

    FocusScope.of(context).unfocus(); // for close kayboard
    setState(() {
      isloading = true;
    });

    try {
      if (_authMode == AuthMode.logIn) {
        try {
          await Provider.of<Auth>(context, listen: false).logIn(
              Provider.of<Auth>(context, listen: false).authData['email'],
              Provider.of<Auth>(context, listen: false).authData['password']);

         

        
          // Navigator.of(context)
          //     .pushReplacementNamed(ProductOverScreen.routeName);

          print('login');
        } catch (e) {
        // 
        }
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
            Provider.of<Auth>(context, listen: false).authData['email'],
            Provider.of<Auth>(context, listen: false).authData['password']);
             setState(() {
            isloading = false;
          });

            
      
        // Navigator.of(context)
        //     .pushReplacementNamed(ProductOverScreen.routeName);
        print('signUp');
      }

     
      
      // } on HttpExepstion catch (error) {
      //   var errorMessage = 'Authentication faild';
      //   if (error.toString().contains("EMAIL_EXISTS")) {
      //     errorMessage = 'this email adress is already in use';
      //   } else if (error.toString().contains("INVALID_EMAIL")) {
      //     errorMessage = 'this is not a valid email address';
      //   } else if (error.toString().contains("WEAK_PASSWORD")) {
      //     errorMessage = 'THIS PASSWORD TOO WEAK';
      //   } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
      //     errorMessage = 'THIS EMAIL NOT FOUND';
      //   } else if (error.toString().contains("INVALID_PASSWORD")) {
      //     errorMessage = 'INVALID_PASSWORD';
      //   }
      //   // toastError(errorMessage);
      //   toast(errorMessage);
      //   // showErrorDailog(errorMessage);
    } catch (error) {
      print(error);
        setState(() {
            isloading = false;
          });
      
    }
     setState(() {
        isloading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        padding: EdgeInsets.all(10),
        curve: Curves.easeInBack,
        constraints:
            BoxConstraints(maxHeight: _authMode == AuthMode.logIn ? 320 : 380),
        width: deviceSize.width * 0.90,
        height: _authMode == AuthMode.logIn ? 280 : 300,
        child: Form(
          key: _formKay,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    labelStyle: TextStyle(fontFamily: "Labo"),
                  ),
                  onSaved: (value) {
                    Provider.of<Auth>(context, listen: false)
                        .authData["email"] = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "password",
                    labelStyle: TextStyle(fontFamily: "Labo"),
                  ),
                  onSaved: (value) {
                    Provider.of<Auth>(context, listen: false)
                        .authData["password"] = value;
                  },
                  obscureText: true,
                  controller: passwordcontroller,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val.isEmpty || val.length < 7) {
                      return "your password short";
                    }
                    return null;
                  },
                ),
                _authMode == AuthMode.singUp
                    ? AnimatedContainer(
                        constraints: BoxConstraints(
                            maxHeight: _authMode == AuthMode.singUp ? 110 : 0,
                            minHeight: _authMode == AuthMode.singUp ? 60 : 0),
                        duration: Duration(microseconds: 400),
                        curve: Curves.easeIn,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
                            enabled: _authMode == AuthMode.singUp,
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle: TextStyle(fontFamily: "Labo"),
                            ),
                            // onSaved: (value) {
                            //   Provider.of<Auth>(context, listen: false)
                            //       .authData["password"] = value;
                            // },
                            obscureText: true,
                            // enabled: authMode == AuthMode.singUp,
                            keyboardType: TextInputType.visiblePassword,
                            validator: _authMode == AuthMode.singUp
                                ? (val) {
                                    if (val != passwordcontroller.text) {
                                      return "your password  not correct";
                                    }
                                    return null;
                                  }
                                : null,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 10,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    isloading == true
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            child: Text(
                              (_authMode == AuthMode.logIn
                                  ? "LogIn"
                                  : "SignUp"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.white12,
                            padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            onPressed: _submit,
                          ),
                    FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "${_authMode == AuthMode.logIn ? "SignUp" : "LogIn"}",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      onPressed: switchAuthMode,
                    ),
                  ],
                ),
                Divider(),
                Center(
                  child: Container(
                      width: deviceSize.width * 0.85,
                      child: FlatButton.icon(
                          splashColor: Colors.purple[100],
                          highlightColor: Colors.purple[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.all(10),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                ProductOverScreen.routeName);
                          },
                          icon: Icon(Icons.login_sharp),
                          label: Text("تسجيل الدخول للزبائن"))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// side: BorderSide.lerp(BorderSide.none,BorderSide.none, 3)),
