import 'package:flutter/material.dart';
import 'package:lojavirtual/screens/sinup_screen.dart';
class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignUpScreen())
              );
            },
            child: Text('CRIAR CONTA', style: TextStyle(fontSize: 15.0)),
            textColor: Colors.white,

          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: 'E-mail'
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (text){
                if (text.isEmpty || !text.contains('@')) return 'E-mail inválido';
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Senha'
              ),
              obscureText: true, //para senhas
                validator: (text){
                  if (text.isEmpty || text.length < 6) return 'Senha inválida';
                }
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () {},
                child: Text('Esqueci minha senha', textAlign: TextAlign.right),
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(height: 16.0),
            RaisedButton(
              child: Text('Entrar', style: TextStyle(fontSize: 18.0)),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: (){
                if (_formKey.currentState.validate()){

                }
              },
            )
          ],
        ),
      ),
    );
  }
}
