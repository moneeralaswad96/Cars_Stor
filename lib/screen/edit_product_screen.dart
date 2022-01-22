import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_firebase/provider/product.dart';
import 'package:shop_firebase/provider/products.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/EditProductScreen ";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // final _priceFocusNode = FocusNode();
  // final _descriptionFocusNode = FocusNode();
  // final _imageUrlController = TextEditingController();
  // final _imageUrlFocusNode = FocusNode();
  // final _formKey = GlobalKey<FormState>();
  // Product _editedProduct =
  //     Product(id: '', description: '', title: '', price: 0, imageUrl: '');

  // var _initialValue = {
  //   'title': '',
  //   'description': '',
  //   'price': "",
  //   'imageUrl': '',
  // };
  // var _isInit = true;
  // var _isloading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _imageUrlFocusNode.addListener(_updateImageUrl);
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (_isInit) {
  //     final productId = ModalRoute.of(context).settings.arguments as String;
  //     if (productId != null) {
  //       _editedProduct =
  //           Provider.of<Products>(context, listen: false).findById(productId);
  //       _initialValue = {
  //         'title': _editedProduct.title,
  //         'description': _editedProduct.description,
  //         'price': _editedProduct.price.toString(),
  //         'imageUrl': '',
  //       };
  //       _imageUrlController.text = _editedProduct.imageUrl;
  //     }
  //     _isInit = false;
  //   }
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _priceFocusNode.dispose();
  //   _descriptionFocusNode.dispose();
  //   _imageUrlController.dispose();
  //   _imageUrlFocusNode.removeListener(_updateImageUrl);
  //   _imageUrlFocusNode.dispose();
  // }

  // void _updateImageUrl() {
  //   if (!_imageUrlFocusNode.hasFocus) {
  //     if (!_imageUrlController.text.startsWith("http") ||
  //         !_imageUrlController.text.startsWith("https") &&
  //             !_imageUrlController.text.endsWith("jpg") ||
  //         !_imageUrlController.text.endsWith("png") ||
  //         !_imageUrlController.text.endsWith("jpeg")) return;
  //   }
  //   setState(() {});
  // }

  // Future<void> _saveForm() async {
  // var isValid = _formKey.currentState.validate();
  // if (!isValid) {
  //   return;
  // }
  // _formKey.currentState.save();
  //   setState(() {
  //     _isloading = true;
  //   });
  //   if (_editedProduct.id != null)
  //     await Provider.of<Products>(context, listen: false)
  //         .updateProduct(_editedProduct.id, _editedProduct);
  //   else {
  //     try {
  //       await Provider.of<Products>(context, listen: true)
  //           .addProduct(_editedProduct);
  //     } catch (e) {
  //       await showDialog(
  //           context: context,
  //           builder: (ctx) => AlertDialog(
  //                 title: Text("error"),
  //                 content: Text('يوجد امر خاطئ'),
  //                 actions: [
  //                   FlatButton(
  //                       onPressed: () => Navigator.of(ctx).pop(),
  //                       child: Text("ok"))
  //                 ],
  //               ));
  //     }
  //   }
  //   setState(() {
  //     _isloading = true;
  //   });
  //   Navigator.of(context).pop();
  // }
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

  String title = "";
  String description = "";
  String price = "";
  String imageUrl = "";

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Title", hintText: "Add title"),
                    onChanged: (val) => setState(() => title = val),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Description", hintText: "Add description"),
                    onChanged: (val) => setState(() => description = val),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Price", hintText: "Add price"),
                    onChanged: (val) => setState(() => price = val),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Image Url",
                        hintText: "Paste your image url here"),
                    onChanged: (val) => setState(() => imageUrl = val),
                  ),
                  SizedBox(height: 30),
                  Container(
                      width: 300,
                      height: 200,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.red[50])),
                      child: FittedBox(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )),
                  SizedBox(height: 30),
                  Consumer<Products>(
                    builder: (ctx, value, _) => FlatButton(
                        color: Colors.purple[200],
                        textColor: Colors.black,
                        child: Text(
                          "اضافة منتج الى المتجر ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          var doublePrice;
                          setState(() {
                            doublePrice = double.tryParse(price) ?? 0.0;
                          });

                          if (title == "" ||
                              description == "" ||
                              price == "" ||
                              imageUrl == "") {
                            toast("ادخل القيم الصحيحة");
                          } else if (doublePrice == 0.0) {
                            toast("ادخل قيمة السعر ");
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            value
                                .add(
                              id: DateTime.now().toString(),
                              title: title,
                              description: description,
                              price: doublePrice,
                              imageUrl: imageUrl,
                            )
                                .catchError((_) {
                              return showDialog<Null>(
                                context: context,
                                builder: (innerContext) => AlertDialog(
                                  title: Text("An error occurred!"),
                                  content: Text('Something went wrong.'),
                                  actions: [
                                    FlatButton(
                                        child: Text("Okay"),
                                        onPressed: () =>
                                            Navigator.of(innerContext).pop())
                                  ],
                                ),
                              );
                            }).then((_) {
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.pop(context);
                            });
                          }
                        }),
                  ),
                ],
              ),
            ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.white12,
  //       actions: [
  //         FlatButton(
  //             onPressed:()async{

  //                await Provider.of<Products>(context, listen: false)
  //           .addProduct(_editedProduct);
  //             } ,
  //             child: Text(
  //               "اضافة منتج",
  //               softWrap: true,
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 17,
  //                   color: Colors.black54),
  //             )),
  //       ],
  //       elevation: 6,
  //       title: Text("Edit Product"),
  //     ),
  //     body: _isloading
  //         ? Center(
  //             child: CircularProgressIndicator(),
  //           )
  //         : Padding(
  //             padding: EdgeInsets.all(8),
  //             child: Form(
  //                 key: _formKey,
  //                 child: ListView(
  //                   children: [
  //                     TextFormField(
  //                       // initialValue: _initialValue['title'],
  //                       decoration: InputDecoration(
  //                         labelText: "Title",
  //                       ),
  //                       textInputAction: TextInputAction.next,
  //                       onFieldSubmitted: (_) {
  //                         FocusScope.of(context).requestFocus(_priceFocusNode);
  //                       },
  //                       validator: (value) {
  //                         if (value.isEmpty) {
  //                           return 'Please provide a value';
  //                         }
  //                         return null;
  //                       },
  //                       onSaved: (value) {
  //                         _editedProduct = Product(
  //                           id: _editedProduct.id,
  //                           description: _editedProduct.description,
  //                           title: value,
  //                           price: _editedProduct.price,
  //                           imageUrl: _editedProduct.imageUrl,
  //                           isFavorite: _editedProduct.isFavorite,
  //                         );
  //                       },
  //                     ),
  //                     TextFormField(
  //                       keyboardType: TextInputType.number,
  //                       focusNode: _priceFocusNode,
  //                       initialValue: _initialValue['price'],
  //                       decoration: InputDecoration(
  //                         labelText: "price",
  //                       ),
  //                       textInputAction: TextInputAction.next,
  //                       onFieldSubmitted: (_) {
  //                         FocusScope.of(context)
  //                             .requestFocus(_descriptionFocusNode);
  //                       },
  //                       validator: (value) {
  //                         if (value.isEmpty) {
  //                           return 'Please inter price';
  //                         }
  //                         if (double.tryParse(value) == null) {
  //                           return 'Please inter correct price';
  //                         }
  //                         if (double.tryParse(value) <= 0) {
  //                           return 'Please inter correct price';
  //                         }
  //                         return null;
  //                       },
  //                       onSaved: (value) {
  //                         _editedProduct = Product(
  //                           id: _editedProduct.id,
  //                           description: _editedProduct.description,
  //                           title: _editedProduct.title,
  //                           price: double.parse(value),
  //                           imageUrl: _editedProduct.imageUrl,
  //                           isFavorite: _editedProduct.isFavorite,
  //                         );
  //                       },
  //                     ),
  //                     TextFormField(
  //                       focusNode: _descriptionFocusNode,
  //                       maxLines: 4,
  //                       keyboardType: TextInputType.multiline,
  //                       initialValue: _initialValue['description'],
  //                       decoration: InputDecoration(
  //                         labelText: "description",
  //                       ),
  //                       textInputAction: TextInputAction.next,
  //                       onFieldSubmitted: (_) {
  //                         FocusScope.of(context)
  //                             .requestFocus(_descriptionFocusNode);
  //                       },
  //                       validator: (value) {
  //                         if (value.isEmpty) {
  //                           return 'Please inter description';
  //                         }

  //                         if (value.length <= 10) {
  //                           return 'Please inter more 10 ';
  //                         }
  //                         return null;
  //                       },
  //                       onSaved: (value) {
  //                         _editedProduct = Product(
  //                           id: _editedProduct.id,
  //                           description: value,
  //                           title: _editedProduct.title,
  //                           price: _editedProduct.price,
  //                           imageUrl: _editedProduct.imageUrl,
  //                           isFavorite: _editedProduct.isFavorite,
  //                         );
  //                       },
  //                     ),
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.end,
  //                       children: [
  //                         Container(
  //                             width: 100,
  //                             height: 100,
  //                             margin: EdgeInsets.only(top: 8, right: 10),
  //                             decoration: BoxDecoration(
  //                                 border: Border.all(
  //                                     width: 1, color: Colors.red[50])),
  //                             child: _imageUrlController.text.isEmpty
  //                                 ? Center(child: Text('ENTER a URL'))
  //                                 : FittedBox(
  //                                     child: Image.network(
  //                                       _imageUrlController.text,
  //                                       fit: BoxFit.cover,
  //                                     ),
  //                                   )),
  //                         Expanded(
  //                           child: TextFormField(
  //                             focusNode: _imageUrlFocusNode,
  //                             maxLines: 4,
  //                             keyboardType: TextInputType.url,
  //                             controller: _imageUrlController,
  //                             decoration: InputDecoration(
  //                               labelText: "Image URL",
  //                             ),
  //                             textInputAction: TextInputAction.next,
  //                             onFieldSubmitted: (_) {
  //                               FocusScope.of(context)
  //                                   .requestFocus(_imageUrlFocusNode);
  //                             },
  //                             validator: (value) {
  //                               if (value.isEmpty) {
  //                                 return 'Please inter URL';
  //                               }

  //                               // if (!value.startsWith('http') ||
  //                               //     !value.startsWith('https')) {
  //                               //   return 'Please inter correct url ';
  //                               // }
  //                               // if (!value.endsWith('jpg') ||
  //                               //     !value.endsWith('png') ||
  //                               //     !value.endsWith('jpeg')) {
  //                               //   return 'Please inter correct url ';
  //                               // }
  //                               return null;
  //                             },
  //                             onSaved: (value) {
  //                               _editedProduct = Product(
  //                                 id: _editedProduct.id,
  //                                 description: _editedProduct.description,
  //                                 title: _editedProduct.title,
  //                                 price: _editedProduct.price,
  //                                 imageUrl: value,
  //                                 isFavorite: _editedProduct.isFavorite,
  //                               );
  //                             },
  //                           ),
  //                         )
  //                       ],
  //                     )
  //                   ],
  //                 )),
  //           ),
  //   );
  // }
}
