import 'package:flutter/material.dart';
void showMessage(BuildContext context, String text, bool errorMessage){
  Scaffold.of(context).showSnackBar(SnackBar(content:
  Text(text),
      backgroundColor: errorMessage ? Colors.redAccent : Theme.of(context).primaryColor));
}