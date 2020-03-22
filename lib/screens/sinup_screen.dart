import 'package:flutter/material.dart';
class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar conta'),
        centerTitle: true
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Nome completo'
              ),
              validator: (text){
                if (text.isEmpty) return 'Nome inválido';
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'E-mail'
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (text){
                if (text.isEmpty || !text.contains('@')) return 'E-mail inválido';
              },
            ),
            SizedBox(height: 16.0), TextFormField(
              decoration: InputDecoration(
                  hintText: 'Endereço'
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (text){
                if (text.isEmpty) return 'Endereço inválido';
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
            SizedBox(height: 16.0),
            RaisedButton(
              child: Text('Criar conta', style: TextStyle(fontSize: 18.0)),
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
