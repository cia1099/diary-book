import 'package:flutter/material.dart';

import 'login_page.dart';

class GettingStartPage extends StatelessWidget {
  const GettingStartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CircleAvatar(
      backgroundColor: Color(0xFFF5F6F8),
      child: Column(
        children: [
          Spacer(),
          Text('DiaryBook', style: Theme.of(context).textTheme.headline3),
          SizedBox(
            height: 40,
          ),
          Text(
            '"Document your life"',
            style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black26),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: 220,
            height: 40,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                  textStyle:
                      TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              icon: Icon(Icons.login_rounded),
              label: Text('Sign in to Get Started'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: '/login'),
                        builder: (context) => LoginPage()));
              },
            ),
          ),
          Spacer(),
        ],
      ),
    ));
  }
}
