import 'dart:io';

import 'package:chat_test/models/authData.dart';
import 'package:chat_test/widgets/userImagePicker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthData authData) onSubmit;

  AuthForm(this.onSubmit);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AuthData _authData = AuthData();

  _submit() {
    bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_authData.image == null && _authData.isSignup) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Precisamos da sua foto!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      widget.onSubmit(_authData);
    }
  }

  void _handlePickedImage(File image) {
    _authData.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_authData.isSignup) UserImagePicker(_handlePickedImage),
                    if (_authData.isSignup)
                      TextFormField(
                        key: ValueKey('name'),
                        decoration: InputDecoration(
                          labelText: 'Nome',
                        ),
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        initialValue: _authData.name,
                        onChanged: (value) => _authData.name = value,
                        validator: (value) {
                          if (value == null || value.trim().length < 4) {
                            return 'Nome deve ter no mínimo 4 caracteres!';
                          }
                          return null;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('email'),
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                      ),
                      onChanged: (value) => _authData.email = value,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'E-mail inválido!';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                      ),
                      onChanged: (value) => _authData.password = value,
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return 'Senha deve ter no mínimo 6 caracteres!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: Text(_authData.isLogin ? 'Entrar' : 'Cadastrar'),
                      onPressed: _submit,
                    ),
                    TextButton(
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                        TextStyle(color: Theme.of(context).primaryColor),
                      )),
                      child: Text(
                        _authData.isLogin
                            ? 'Criar uma nova conta?'
                            : 'Já possui uma conta?',
                      ),
                      onPressed: () {
                        setState(() {
                          _authData.toggleMode();
                        });
                      },
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
