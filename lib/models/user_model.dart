import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

//o Model vem do scoped_model.dart. Um obj que guarda o estado de alguma coisa para ser usado em qq lugar do aplicativo
class UserModel extends Model {
  bool isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();


  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
      _loadCurrentUSer();
  }

  void signUp(Map<String, dynamic> userData, String pass, VoidCallback onSuccess, VoidCallback onFail) {
    isLoading = true;
    notifyListeners();
     _auth.createUserWithEmailAndPassword(
        email: userData['email'], password: pass).
    then((result) async{
      firebaseUser = result.user; //

      await _saveUserData(userData);
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void singIn(String email, String pass, VoidCallback onSuccess, VoidCallback onFail) async {
    isLoading = true;
    notifyListeners(); //notifica quem está dentro do ScopedModel em outros lugares

    _auth.signInWithEmailAndPassword(email: email, password: pass).then((result) {
      firebaseUser = result.user;
      _loadCurrentUSer();

      onSuccess();
      isLoading = false;
      notifyListeners();

    }).catchError((e){

      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email).then((result){
    //  print(result);
    }).catchError((e){
    //  print(e);
    });
  }

  void signOut(){
    _auth.signOut();
    firebaseUser = null;
    userData = Map();
    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async{
    this.userData = userData;
    await Firestore.instance.collection('users').document(firebaseUser.uid).setData(userData);
  }

  Future<Null> _loadCurrentUSer() async{
    if (firebaseUser == null)
      firebaseUser = await _auth.currentUser();
    else{
      if (userData['name'] == null){
        DocumentSnapshot docUser = await Firestore.instance.collection('users').document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }
}
