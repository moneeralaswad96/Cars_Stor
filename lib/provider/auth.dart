// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_expestion.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Auth with ChangeNotifier {
  Map<String, String> authData = {
    "email": "",
    "password": "",
  };

  String token;
  String userId;
  Timer authTimer;

  bool get isAuth {
    return token != null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCReZLOSZEGHeHqHHO9qnfWum-ozn7xcHg";
    try {
      var res = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final resData = await json.decode(res.body);

      if (resData['error'] != null) {
        toast(resData['error']['message']);
      }
      token = resData['idToken'];
      userId = resData['localId'];

      print('Token=$token');

      //  autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      String userData = json.encode({
        "token": token,
        "userId": userId,
        //  "expiryDate": _expiryDate.toIso8601String(),
      });
      prefs.setString("userData", userData);
    } catch (error) {
      var errorMessage = 'Authentication faild';
      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = 'this email adress is already in use';
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = 'this is not a valid email address';
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = 'THIS PASSWORD TOO WEAK';
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = 'THIS EMAIL NOT FOUND';
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = 'INVALID_PASSWORD';
      }
      toast("$errorMessage");
    }
  }

  void toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return;
    final Map<String, Object> extractData =
        json.decode(prefs.getString("userData")) as Map<String, dynamic>;

    token = extractData['token'];
    userId = extractData['userId'];

    notifyListeners();
    // autoLogout();
  }

  Future<void> logOut() async {
    token = null;
    userId = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  //  void autoLogout() {
  //    if (_authTimer != null) {
  //      _authTimer.cancel();
  //    }
  //   final timeToExpairy = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpairy), logOut);
  // }

  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   try {
  //     final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     notifyListeners();

  //     // Once signed in, return the UserCredential
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  // Future<void> phoneAuth(var phoneNumber) async {
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber:phoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) {},
  //     verificationFailed: (FirebaseAuthException e) {},
  //     codeSent: (String verificationId, int resendToken) {},
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   );
  // }
}
