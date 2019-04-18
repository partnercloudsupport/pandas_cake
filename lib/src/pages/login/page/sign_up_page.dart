import 'package:flutter/material.dart';
import 'package:pandas_cake/src/pages/login/bloc/sign_up_bloc.dart';
import 'package:pandas_cake/src/pages/login/widgets/login_flat_button.dart';
import 'package:pandas_cake/src/pages/login/widgets/login_form_text_field.dart';
import 'package:pandas_cake/src/pages/login/widgets/login_raised_button.dart';
import 'package:pandas_cake/src/utils/bloc_base.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  SignUpBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<SignUpBloc>(context);

    return StreamBuilder(
      stream: bloc.getLoading,
      builder: (context, isLoading) => Form(
            key: bloc.getFormKey,
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(8.0)),
                LoginTextFormField(
                  label: 'Nome',
                  error: 'Informe um nome',
                  onSave: (value) => bloc.getUser.name = value,
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                LoginTextFormField(
                  label: 'E-mail',
                  error: 'Informe um e-mail válido',
                  onSave: (value) => bloc.getUser.email = value,
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                LoginTextFormField(
                  label: 'Senha',
                  error: 'Informe uma senha',
                  onSave: (value) => bloc.getUser.password = value,
                  obscureText: true,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  alignment: FractionalOffset(0.0, 0.5),
                  child: new Text(
                    'Sexo',
                    textAlign: TextAlign.left,
                    style: new TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
                StreamBuilder<Object>(
                  stream: bloc.getSexChange,
                  builder: (context, sex) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Radio(
                            value: 'M',
                            groupValue: sex.data.toString(),
                            onChanged: bloc.handleRadioSexChange,
                          ),
                          Text('Masculino'),
                          Radio(
                            value: 'F',
                            groupValue: sex.data.toString(),
                            onChanged: bloc.handleRadioSexChange,
                          ),
                          Text('Feminino')
                        ],
                      ),
                ),
                LoginRaisedButton(
                  label: 'Create account',
                  isLoading: isLoading.hasData && isLoading.data,
                  onPress: () => bloc.validateAndSubmit(context),
                ),
                LoginFlatButton(
                  label: 'Have an account? Login',
                  onPress: bloc.onLogin,
                ),
              ],
            ),
          ),
    );
  }
}
