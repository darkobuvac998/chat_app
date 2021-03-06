import 'package:flutter/material.dart';
import 'dart:io';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final isLoading;
  final void Function(BuildContext ctx, String email, String password,
      String username, bool isLogin, File? userImage) onSubmit;
  const AuthForm({
    required this.isLoading,
    required this.onSubmit,
    Key? key,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  var _isLogin = true;
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) {
      return;
    }

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: const Text(
            'Please pick an image.',
          ),
        ),
      );
      return;
    }

    widget.onSubmit(
      context,
      _userEmail.trim(),
      _userPassword.trim(),
      _userName.trim(),
      _isLogin,
      _userImageFile,
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
                  if (!_isLogin)
                    UserImagePicker(
                      imagePickFn: _pickedImage,
                    ),
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
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(
                        _isLogin ? 'Login' : 'Signup',
                      ),
                    ),
                  if (!widget.isLoading)
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
