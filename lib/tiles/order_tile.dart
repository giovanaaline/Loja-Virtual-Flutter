import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class OrderTile extends StatelessWidget {
  final String orderId;
  OrderTile(this.orderId);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
//          StreamBuilder fica "ouvindo" as mudanças no banco de dados e muda assim que sofre uma mudança
          child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance.collection('orders').document(orderId).snapshots(),
              builder: (context, snapshot){
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                else{
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Código do pedido: ${snapshot.data.documentID}', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4.0),
                      Text(_builProductText(snapshot.data)),
                      SizedBox(height: 4.0),
                      Text('Status do pedido:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildCircle('1', 'Preparação', snapshot.data['status'], 1),
                          Container(
                            height: 1.0,
                            width: 40.0,
                            color: Colors.grey[500],
                          ),
                          _buildCircle('2', 'Transporte', snapshot.data['status'], 2),
                          Container(
                            height: 1.0,
                            width: 40.0,
                            color: Colors.grey[500],
                          ),
                          _buildCircle('3', 'Entrega', snapshot.data['status'], 3),
                        ],
                      )
                    ],
                  );
                }
              }),
        )
    );
  }
  String _builProductText(DocumentSnapshot snapshot){
    var dateFormat = new DateFormat('dd/MM/yyyy HH:mm');
    Timestamp dt = snapshot.data['dataOrder'];
    String text = 'Descrição:\nData: ${dateFormat.format(new DateTime.fromMicrosecondsSinceEpoch(dt.microsecondsSinceEpoch))}\n';
//    LinkedHashMap é o formato dos products dentro da coleção orders
    for (LinkedHashMap p in snapshot.data['products']){
        text += '${p['quantity']} x ${p['product']['title']} (R\$ ${p['product']['price'].toStringAsFixed(2)})\n';
    }
    text += 'Total: R\$ ${snapshot.data['totalOrder'].toStringAsFixed(2)}';
    return text;
  }

  Widget _buildCircle(String title, String subtitle, int status, int thisStatus){
    Color backColor;
    Widget child;

    if (status < thisStatus){
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    }else  if (status == thisStatus){
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    }else{
      backColor = Colors.green;
      child = Icon(Icons.check);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle),
      ],
    );
  }
}
