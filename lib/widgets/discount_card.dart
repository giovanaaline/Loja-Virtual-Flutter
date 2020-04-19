import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/widgets/snackbar.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          'Cupom de desconto',
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Digite seu cupom'),
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (text){
                Firestore.instance.collection('coupons').document(text).get().then((snapDoc){
                  if (snapDoc.data != null){
                    CartModel.of(context).setCoupon(text, snapDoc.data['percentage']);
                    showMessage(context, 'Desconto de ${snapDoc.data['percentage']}% aplicado', false);
                  }else{
                    CartModel.of(context).setCoupon(null, 0);
                    showMessage(context, 'Cupom inexistente', true);
                  }
                }).catchError((e){
                  showMessage(context, 'Erro na obtenção de dados do cupom', true);
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
