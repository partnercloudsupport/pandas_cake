import 'package:flutter/material.dart';
import 'package:pandas_cake/services/auth.dart';
import 'package:pandas_cake/dto/user.dart';
import 'package:pandas_cake/utils/firebase_util.dart';

enum FormType { login, register }

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  User user = new User();
  FormType _formType = FormType.login;
  bool _isLoading = false;

  bool _validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      setState(() {
        _isLoading = false;
      });
      return false;
    }
  }

  void _validateAndSubmit(BuildContext context) async {
    AuthStatus status;
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      if (_validateAndSave()) {
        try {
          if (_formType == FormType.login) {
            status = await widget.auth.signInWithEmailAndPassword(user);
          } else {
            status = await widget.auth.createUserWithEmailAndPassword(user);
          }
          if (status == AuthStatus.SUCCESS) {
            widget.onSignedIn();
          } else {
            setState(() {
              _isLoading = false;
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text(FireBaseUtil().getMessage(status)),
              ));
            });
          }
        } catch (e) {
          print('Error: $e');
        }
      }
    }
  }

  void _moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void _moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  void _handleRadioSexChange(String value) {
    setState(() {
      user.sex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
        backgroundColor: Colors.pink[200],
      ),
      body: Builder(
          builder: (context) => Container(
              padding: EdgeInsets.all(16.0),
              child: new Form(
                key: formKey,
                child: new ListView(
                    children: _buildDisplayImage(context) +
                        _buildInputs() +
                        _buildSubmitsButtons(context)),
              ))),
    );
  }

  List<Widget> _buildInputs() {
    if (_formType == FormType.login) {
      return _buildSignIn();
    } else {
      return _buildSignUp();
    }
  }

  List<Widget> _buildSignIn() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => user.email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        obscureText: true,
        onSaved: (value) => user.password = value,
      ),
    ];
  }

  List<Widget> _buildSignUp() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Nome'),
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        onSaved: (value) => user.name = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'E-mail'),
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        onSaved: (value) => user.email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Senha'),
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        obscureText: true,
        onSaved: (value) => user.password = value,
      ),
      new Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: new Text(
          'Sexo',
          style: new TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Radio(
              value: 'M',
              groupValue: user.sex,
              onChanged: _handleRadioSexChange),
          new Text('Masculino'),
          new Radio(
              value: 'F',
              groupValue: user.sex,
              onChanged: _handleRadioSexChange),
          new Text('Feminino')
        ],
      )
    ];
  }

  List<Widget> _buildSubmitsButtons(BuildContext context) {
    var primaryButton;
    var secondaryButton;
    if (_formType == FormType.login) {
      primaryButton = new RaisedButton(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0)),
        color: Colors.brown[400],
        onPressed: () => _validateAndSubmit(context),
        child: !_isLoading
            ? new Text('Login', style: new TextStyle(fontSize: 20.0))
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
      );
      secondaryButton = new FlatButton(
          onPressed: _moveToRegister,
          child: new Text('Create an account',
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)));
    } else {
      primaryButton = new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
          color: Colors.brown[400],
          onPressed: () => _validateAndSubmit(context),
          child: !_isLoading
              ? new Text('Create account', style: new TextStyle(fontSize: 20.0))
              : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ));
      secondaryButton = new FlatButton(
          onPressed: _moveToLogin,
          child: new Text('Have an account? Login',
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)));
    }

    return [
      new Padding(
          padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
          child: ButtonTheme(height: 45.0, child: primaryButton)),
      secondaryButton
    ];
  }

  List<Widget> _buildDisplayImage(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return [
      new Container(
        width: media.size.width / 5,
        height: media.size.height / 5,
        child: new DecoratedBox(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: new AssetImage('assets/logo_panda.png'))),
        ),
      )
    ];
  }
}
