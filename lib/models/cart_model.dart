import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/cart_data.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{
  UserModel user;
  List<CartProduct> products = [];
  CartModel(this.user);

  bool isLoading = false;

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
    notifyListeners();
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
}