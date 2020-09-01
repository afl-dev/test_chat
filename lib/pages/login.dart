import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_chat/bloc/login/login_bloc.dart';
import 'package:test_chat/pages/chat.dart';

// ignore: use_key_in_widget_constructors
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  var _userName = '';

  void _trySubmit() {
    // Валидация
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_isValid) {
      // Отправляем эвент в блок
      BlocProvider.of<LoginBloc>(context).add(SubmitLogin(_userName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
        if (state is LoginError) {
          // показываем снекбар если серер не доступен
          const snackBar = SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Сервер не доступен, попробуйте снова',
                textAlign: TextAlign.center,
              ));
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snackBar);
        }
      }, builder: (context, state) {
        if (state is LoginLoading) {
          return const Center(
            child: Card(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is LoginLoaded) {
          return ChatPage(user: state.user);
        }
        return Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      autocorrect: true,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      // Валидация
                      validator: (value) {
                        if (value.isEmpty || value.length < 3) {
                          return 'Пожалуйста введите более 3-х символов';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Имя пользователя'),
                      onSaved: (value) {
                        _userName = value;
                      },
                      onChanged: (value) {
                        _userName = value;
                      },
                    ),
                    const SizedBox(height: 12),
                    RaisedButton(
                      child: const Text('Логин'),
                      onPressed: _trySubmit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
