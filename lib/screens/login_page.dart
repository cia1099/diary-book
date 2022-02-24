import 'package:flutter/material.dart';
import 'package:web_practice/widgets/login_form.dart';
import 'package:web_practice/widgets/create_account.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();

  final TextEditingController _passwordTextController = TextEditingController();

  final GlobalKey<FormState>? _globalKey = GlobalKey<FormState>();
  bool isCreatedAccountClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(color: Color(0xFFB9C2D1)),
            ),
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(
                    width: 300,
                    height: 300,
                    child: isCreatedAccountClicked
                        ? CreateAccountForm(
                            formKey: _globalKey,
                            ctx: context,
                            emailTextController: _emailTextController,
                            passwordTextController: _passwordTextController)
                        : LoginForm(
                            formKey: _globalKey,
                            ctx: context,
                            emailTextController: _emailTextController,
                            passwordTextController: _passwordTextController)),
                TextButton.icon(
                    onPressed: () {
                      setState(() {
                        isCreatedAccountClicked ^= true;
                      });
                    },
                    icon: Icon(Icons.portrait_rounded),
                    label: Text(
                      isCreatedAccountClicked
                          ? 'Already have an account?'
                          : 'Create Account',
                    ),
                    style: TextButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: 18, fontStyle: FontStyle.italic))),
              ],
            ),
            Expanded(
                flex: 2,
                child: Container(
                  color: Color(0xFFB9C2D1),
                ))
          ],
        ),
      ),
    );
  }
}
