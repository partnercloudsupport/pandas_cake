import 'package:flutter/material.dart';
import 'package:pandas_cake/src/pages/login/bloc/sign_in_bloc.dart';
import 'package:pandas_cake/src/pages/login/widgets/login_flat_button.dart';
import 'package:pandas_cake/src/pages/login/widgets/login_raised_button.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';
import 'package:pandas_cake/src/pages/login/widgets/login_form_text_field.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignInPage> {
  SignInBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<SignInBloc>(context);

    return StreamBuilder(
      stream: bloc.getLoading,
      builder: (context, isLoading) => Form(
            key: bloc.getFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(8.0)),
                LoginTextFormField(
                  label: 'Email',
                  error: 'Email can\'t be empty',
                  onSave: (value) => bloc.getUser.email = value,
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                LoginTextFormField(
                  label: 'Password',
                  error: 'Password can\'t be empty',
                  onSave: (value) => bloc.getUser.password = value,
                  obscureText: true,
                ),
                LoginRaisedButton(
                  label: 'Login',
                  isLoading: isLoading.hasData && isLoading.data,
                  onPress: () => bloc.validateAndSubmit(context),
                ),
                LoginFlatButton(
                  label: 'Criar uma conta',
                  onPress: bloc.onCreateAccount,
                )
              ],
            ),
          ),
    );
  }
}
