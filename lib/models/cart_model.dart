import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/cart_data.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{
  UserModel user;
  List<CartProduct> products = [];

  String couponCode;
  int discountPercentage = 0;
  bool isLoading = false;

  CartModel(this.user){
    if (user.isLoggedIn())
      _loadCartItems();
  }
  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);
    loadDataCart().add(cartProduct.toMap()).then((doc){
      cartProduct.cid = doc.documentID;
    });
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    loadDataCart().document(cartProduct.cid).delete();
    products.remove(CartProduct);
//    na aula não tinha essa anotação. so funcionou no meu quando eu coloquei o loadCartItems
    _loadCartItems();
  }

  void dec_inc_Product(CartProduct cartProduct, int soma){
    cartProduct.quantity += soma;
    loadDataCart().document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  CollectionReference loadDataCart(){
    return Firestore.instance.collection('users').document(user.firebaseUser.uid).
    collection('cart');
  }

  void _loadCartItems() async{
    QuerySnapshot query = await loadDataCart().getDocuments();
    
    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }
}