import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _scafoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
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
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if (model.isLoading)
            return Center(child: CircularProgressIndicator());
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
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
                    controller: _passController,
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
                    onPressed: () {
                      if (_emailController.text.isEmpty){
                        _snackBar('Insira seu e-mail', Colors.red);
                      }
                      else{
                        model.recoverPass(_emailController.text);
                        _snackBar('Confira seu e-mail', Theme.of(context).primaryColor);
                      }
                    },
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
                      model.singIn(_emailController.text, _passController.text, _onSuccess, _onFail);
                    }

                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess(){
      Navigator.of(context).pop();
  }

  void _onFail(){
//    _scafoldKey.currentState.showSnackBar(
//        SnackBar(
//            content: Text('Problemas ao se logar'),
//            backgroundColor: Colors.red,
//            duration: Duration(seconds: 2))
//    );
    _snackBar('Problemas ao se logar', Colors.red);
  }

  void _snackBar(String text, Color cor){
    _scafoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text(text),
            backgroundColor: cor,
            duration: Duration(seconds: 2))
    );
  }
}
