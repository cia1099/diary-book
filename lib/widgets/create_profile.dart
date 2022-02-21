import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_practice/model/user.dart';
import 'package:web_practice/screens/login_page.dart';
import 'package:web_practice/widgets/update_user_profile_dialog.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final MUser currentUser;

  @override
  Widget build(BuildContext context) {
    final _avatarUrlTextController =
        TextEditingController(text: currentUser.avatarUrl);
    final _nameTextController = TextEditingController(text: currentUser.name);
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Expanded(
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(currentUser.avatarUrl),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => UpdateUserProfileDialog(
                            currentUser: currentUser,
                            avatarUrlTextController: _avatarUrlTextController,
                            nameTextController: _nameTextController));
                  },
                ),
              ),
              Text(
                currentUser.name,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((value) => Navigator.pushReplacementNamed(
                        context,
                        // MaterialPageRoute(
                        //   settings: RouteSettings(name: '/login'),
                        //   builder: (context) => LoginPage(),
                        // )
                        '/login'));
              },
              icon: const Icon(
                Icons.logout_outlined,
                size: 19,
                color: Colors.redAccent,
              ))
        ],
      ),
    );
  }
}
