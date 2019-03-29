import 'package:flutter/material.dart';
import 'package:pandas_cake/src/blocs/bloc_base.dart';
import 'package:pandas_cake/src/blocs/login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      body: Builder(
          builder: (context) => Container(
              padding: EdgeInsets.all(16.0),
              margin: MediaQuery.of(context).padding,
              child: new Form(
                  key: bloc.getFormKey,
                  child: new ListView(children: <Widget>[
                    _buildDisplayImage(context),
                    _body(),
                  ])))),
    );
  }

  Widget _body() {
    return StreamBuilder(
      stream: bloc.getFormType,
      builder: (context, formType) =>
          formType.data == FormType.login ? _signIn() : _signUp(),
    );
  }

  Widget _buildDisplayImage(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width / 5,
      height: MediaQuery.of(context).size.height / 5,
      child: new DecoratedBox(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: new AssetImage('assets/logo_panda.png'))),
      ),
    );
  }

  Widget _signIn() {
    return StreamBuilder(
      stream: bloc.getLoading,
      builder: (context, isLoading) => Column(
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) =>
                    value.isEmpty ? 'Email can\'t be empty' : null,
                onSaved: (value) => bloc.getUser.email = value,
              ),
              new TextFormField(
                style: Theme.of(context).textTheme.body1,
                decoration: new InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) =>
                    value.isEmpty ? 'Password can\'t be empty' : null,
                obscureText: true,
                onSaved: (value) => bloc.getUser.password = value,
              ),
              new SizedBox(
                  width: double.infinity,
                  child: new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                      child: ButtonTheme(
                        height: 45.0,
                        child: new RaisedButton(
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          color: Theme.of(context).primaryColor,
                          onPressed: () => bloc.validateAndSubmit(context),
                          child: (isLoading.hasData && !isLoading.data)
                              ? new Text('Login',
                                  style: new TextStyle(fontSize: 20.0))
                              : CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).accentColor),
                                ),
                        ),
                      ))),
              new SizedBox(
                  width: double.infinity,
                  child: new FlatButton(
                      onPressed: bloc.moveToRegister,
                      child: new Text('Create an account',
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w300))))
            ],
          ),
    );
  }

  Widget _signUp() {
    return StreamBuilder(
      stream: bloc.getLoading,
      builder: (context, isLoading) => Column(
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) => bloc.getUser.name = value,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'E-mail'),
                validator: (value) =>
                    value.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) => bloc.getUser.email = value,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Senha'),
                validator: (value) =>
                    value.isEmpty ? 'Campo obrigatório' : null,
                obscureText: true,
                onSaved: (value) => bloc.getUser.password = value,
              ),
              new Container(
                margin: const EdgeInsets.only(top: 16.0),
                alignment: FractionalOffset(0.0, 0.5),
                child: new Text(
                  'Sexo',
                  textAlign: TextAlign.left,
                  style: new TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Radio(
                    value: 'M',
                    groupValue: bloc.getUser.sex,
                    onChanged: bloc.handleRadioSexChange,
                  ),
                  new Text('Masculino'),
                  new Radio(
                      value: 'F',
                      groupValue: bloc.getUser.sex,
                      onChanged: bloc.handleRadioSexChange),
                  new Text('Feminino')
                ],
              ),
              new SizedBox(
                  width: double.infinity,
                  child: new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                      child: ButtonTheme(
                        height: 45.0,
                        child: new RaisedButton(
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                          color: Theme.of(context).primaryColor,
                          onPressed: () => bloc.validateAndSubmit(context),
                          child: (isLoading.hasData && !isLoading.data)
                              ? new Text('Create account',
                                  style: new TextStyle(fontSize: 20.0))
                              : CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).accentColor),
                                ),
                        ),
                      ))),
              new SizedBox(
                  width: double.infinity,
                  child: new FlatButton(
                      onPressed: bloc.moveToLogin,
                      child: new Text('Have an account? Login',
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w300))))
            ],
          ),
    );
  }
}
