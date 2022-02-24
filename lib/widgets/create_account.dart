import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_practice/model/user.dart';
import 'package:web_practice/screens/main_page.dart';
import 'package:web_practice/services/service.dart';

import 'input_decorator.dart';

class CreateAccountForm extends StatelessWidget {
  CreateAccountForm({
    Key? key,
    required TextEditingController emailTextController,
    required TextEditingController passwordTextController,
    GlobalKey<FormState>? formKey,
    required this.ctx,
  })  : _emailTextController = emailTextController,
        _passwordTextController = passwordTextController,
        _globalKey = formKey,
        super(key: key);

  final TextEditingController _emailTextController;
  final TextEditingController _passwordTextController;
  final GlobalKey<FormState>? _globalKey;
  final _passwordFocusNode = FocusNode();
  final _createFocusNode = FocusNode();
  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Please enter a valid email and password that is at least 6 character.'),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? 'Please enter an email' : null;
              },
              controller: _emailTextController,
              decoration: buildInputDecoration('email', 'john@gmail.com'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_passwordFocusNode),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? 'Please enter a password' : null;
              },
              obscureText: true,
              controller: _passwordTextController,
              decoration: buildInputDecoration('password', ''),
              textInputAction: TextInputAction.next,
              focusNode: _passwordFocusNode,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_createFocusNode),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              focusNode: _createFocusNode,
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(fontSize: 18)),
              onPressed: () {
                if (_globalKey!.currentState!.validate()) {
                  final email = _emailTextController.text;
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    if (value.user != null) {
                      DiaryService()
                          .createUser(
                              email.split('@')[0], context, value.user!.uid)
                          .then((value) {
                        DiaryService()
                            .loginUser(email, _passwordTextController.text)
                            .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainPage(),
                                )));
                      });
                    }
                  }).onError<FirebaseAuthException>((error, _) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                        content: Text(
                      error.message!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    )));
                  });
                }
              },
              child: Text('Create Account'))
        ],
      ),
    );
  }
}
