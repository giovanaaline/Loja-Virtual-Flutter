import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/login_screen.dart';
import 'package:lojavirtual/screens/order_screen.dart';
import 'package:lojavirtual/tiles/cart_tile.dart';
import 'package:lojavirtual/widgets/cart_price.dart';
import 'package:lojavirtual/widgets/discount_card.dart';
import 'package:lojavirtual/widgets/ship_card.dart';
import 'package:lojavirtual/widgets/snackbar.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
          title: Text('Meu Carrinho'),
          centerTitle: true,
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 8.0),
              child: ScopedModelDescendant<CartModel>(
                builder: (context, child, model) {
                  int qtd = model.products.length;
                  return Text('${qtd ?? 0} ${qtd == 1 ? 'ITEM' : 'ITENS'}',
                      style: TextStyle(fontSize: 17.0));
                },
              ),
            )
          ]),
      body: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            bool isUserLoggedIn = UserModel.of(context).isLoggedIn();
            if ((model.isLoading) && (isUserLoggedIn)) {
              return Center(child: CircularProgressIndicator());
            }
           else if (!isUserLoggedIn) {
              return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.remove_shopping_cart,
                            size: 80.0, color: primaryColor),
                        SizedBox(height: 16.0),
                        Text('Faça o login para adicionar os produtos',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        SizedBox(height: 16.0),
                        RaisedButton(
                            child: Text(
                                'Entrar', style: TextStyle(fontSize: 18.0)),
                            textColor: Colors.white,
                            color: primaryColor,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            })
                      ]
                  )
              );
            }else if(model.products == null || model.products.length == 0){
             return Center(child: Text('Nenhum produto no carrinho',
                 style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
             );
            }
            else{
              return ListView(
                children: <Widget>[
                  Column(
                    children: model.products.map((product){
                      return CartTile(product);
                    }).toList(),
                  ),
                  DiscountCard(),
                  ShipCard(),
                  CartPrice(() async{
                    String orderId = await model.finishedOrder();
                    if (orderId == null)
                      showMessage(context, 'Erro ao finalizar o pedido');
                    else{
                     Navigator.of(context).pushReplacement(
                       MaterialPageRoute(builder: (context) => OrderScreen(orderId))
                     );
                    }                      
                  })
                ],
              );
            }
          }
      )
    );
  }
}
