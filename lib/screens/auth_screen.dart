import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<void> _submitAuthForm(BuildContext ctx, String email, String password,
      String username, bool isLogin, File? userImage) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child(
              'user_images',
            )
            .child(
              authResult.user!.uid + '.jpg',
            );

        await ref
            .putFile(
              userImage!,
            )
            .whenComplete(() => null);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(
              authResult.user?.uid,
            )
            .set(
          {
            'username': username,
            'email': email,
            'imageUrl': url
          },
        );
      }
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (error) {
      String? message = 'An error occured, please check your credentials';

      if (error.message != null) {
        message = error.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text(message ?? ''),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        isLoading: _isLoading,
        onSubmit: _submitAuthForm,
      ),
    );
  }
}
