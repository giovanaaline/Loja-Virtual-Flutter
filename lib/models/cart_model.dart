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
    notifyListeners();
  }

  double getProductsPrice(){
    double price = 0.0;
    for (CartProduct c in products){
      if (c.productData != null){
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  double getDiscount(){
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice(){
    return 9.99;
  }

  void updatePrice(){
    notifyListeners();
  }

  Future<String> finishedOrder() async{
    if (products.length == 0) return null;
    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
//grava os pedidos na coleção orders
    DocumentReference docRef = await Firestore.instance.collection('orders').add({
      'clientId': user.firebaseUser.uid,
      'discount': discount,
      'shipPrice': shipPrice,
      'productsPrice': productsPrice,
      'totalOrder': productsPrice - discount + shipPrice,
      'status': 1,
      'dataOrder': new DateTime.now(),
      'products': products.map((cartProduct) => cartProduct.toMap()).toList()
    });

//    grava para o usuário a referencia do seu pedido
    await Firestore.instance.collection('users').document(user.firebaseUser.uid).
    collection('orders').document(docRef.documentID).setData({'orderId':docRef.documentID});

//    apaga os produtos do carrinho pois a compra foi feita
    QuerySnapshot query = await loadDataCart().getDocuments();
    for (DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

//    limpa os produtos
    products.clear();

    couponCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();

    return docRef.documentID;
  }
}