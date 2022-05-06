import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(BuildContext ctx, String email, String password,
      String username, bool isLogin) onSubmit;
  const AuthForm({required this.onSubmit, Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  var _isLogin = true;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) {
      return;
    }

    widget.onSubmit(
      context,
      _userEmail.trim(),
      _userPassword.trim(),
      _userName.trim(),
      _isLogin,
    );

    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(
          20,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const ValueKey('Email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please provide a valid emai address.';
                      }
                      if (!value.contains('@')) {
                        return 'Please provide a valid emai address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value ?? '';
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('Username'),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter a value.';
                        }
                        if (value.length <= 4) {
                          return 'Please enter at least 5 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value ?? '';
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('Password'),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter a password';
                      }
                      if (value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value ?? '';
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: _trySubmit,
                    child: Text(
                      _isLogin ? 'Login' : 'Signup',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? 'Create a new account'
                          : 'I already have an account',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
