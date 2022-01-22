import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/http_expestion.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
// import '../provider/auth.dart';

class Products with ChangeNotifier {
  List<Product> items = [
    
  ];
  String authToken;
  String userId;

  getData(String authTok, String uId, List<Product> prodcuts) {
    authToken = authTok;
    userId = uId;
    items = prodcuts;
    notifyListeners();
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



  List<Product> get favoritesItems {
    return items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

Future<void> fetchData() async {
    final url =  "https://shop-firebase-b910f-default-rtdb.firebaseio.com/products.json";
    try {
      final http.Response res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      extractedData.forEach((prodId, prodData) {
        final prodIndex =
            items.indexWhere((element) => element.id == prodId);
        if (prodIndex >= 0) {
          items[prodIndex] = Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
          );
        } else {
          items.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
          ));
        }
      });

      notifyListeners();
    } catch (error) {
      toast("");
    }
  }


  
  Future<void> fecthAndSetProducts([bool filterByUser = false]) async {
    final filteredString = filterByUser
        ? 'orderBy="creatorId"&equalTo=$userId'
        : ''; // bcause filter users
    var url =
        "https://shop-firebase-b910f-default-rtdb.firebaseio.com/products.json";

    try {
      final res = await http.get(url);
      final extractData = json.decode(res.body) as Map<String, dynamic>;
      if (extractData == null) return;
      url =
          "https://shop-firebase-b910f-default-rtdb.firebaseio.com/userFavorites.json";

      final favRes = await http.get(url);
      final favData = json.decode(favRes.body) as Map<String, dynamic>;

      // List<Product> loadedProducts = [];
      extractData.forEach((prodId, prodData) {
        items.add(Product(
          id: prodId,
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          title: prodData['title'],
          isFavorite: favData == null ? false : favData[prodId] ?? false,
        ));
      });

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }



 Future<void> add({String id,String title, String description,double price, String imageUrl}) 
 async {
   final url = "https://shop-firebase-b910f-default-rtdb.firebaseio.com/products.json";
    try {
      http.Response res = await http.post(Uri.parse(url),
          body: json.encode({
            "title": title,
            "description": description,
            "price": price,
            "imageUrl": imageUrl,
          }));
      // print(json.decode(res.body));

      items.add(Product(
        id: json.decode(res.body)['name'],
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
      ));
      notifyListeners();
    } catch (e) {
      toast("add=$e");
    }
  }
  
  
  
  Future<void> addProduct(Product product) async {
    var url =
        "https://shop-firebase-b910f-default-rtdb.firebaseio.com/products.json";

    try {
      var res = await http.post(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            // "creatorId": userId,
          }));

      print("add product");
      Product newProduct = Product(
          id: json.decode(res.body)["name"],
          description: product.description,
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl);
      items.add(newProduct);
      print("تمت الاضافة ");
      notifyListeners();
    } catch (e) {
      toast("add=$e");
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = items.indexWhere((prod) => prod.id == id);

    try {
      if (prodIndex >= 0) {
        final url =
            "https://shop-firebase-b910f-default-rtdb.firebaseio.com/products/$id.json";
        var res = await http.patch(url,
            body: json.encode({
              "title": newProduct.title,
              "price": newProduct.price,
              "description": newProduct.description,
              "imageUrl": newProduct.imageUrl,
            }));

        items[prodIndex] = newProduct;
        notifyListeners();
        print('${json.encode(res.body)}');
      }
    } catch (e) {
      throw e;
      // toast("update=$e");
    }
  }

  Future<void> deleteProduct(String id) async {
    var url =
        "https://shop-firebase-b910f-default-rtdb.firebaseio.com/products/$id.json";

    final existingproductIndex = items.indexWhere((prod) => prod.id == id);
    var existingproduct = items[existingproductIndex];
    items.remove(existingproductIndex);
    notifyListeners();
    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      items.insert(existingproductIndex, existingproduct);
      notifyListeners();
      toast("لايمكن الحذف يوجد خطأ");
    }
    existingproduct = null;
  }
}
// Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),