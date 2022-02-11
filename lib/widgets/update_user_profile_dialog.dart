import 'package:flutter/material.dart';
import 'package:web_practice/model/user.dart';
import 'package:web_practice/services/service.dart';

class UpdateUserProfileDialog extends StatelessWidget {
  const UpdateUserProfileDialog({
    Key? key,
    required this.currentUser,
    required TextEditingController avatarUrlTextController,
    required TextEditingController nameTextController,
  })  : _avatarUrlTextController = avatarUrlTextController,
        _nameTextController = nameTextController,
        super(key: key);

  final MUser currentUser;
  final TextEditingController _avatarUrlTextController;
  final TextEditingController _nameTextController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * 0.40,
        height: MediaQuery.of(context).size.height * 0.40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Editing ${currentUser.name}',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _avatarUrlTextController,
                    ),
                    TextFormField(
                      controller: _nameTextController,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.green,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                side:
                                    BorderSide(color: Colors.green, width: 1))),
                        child: Text('Update'),
                        onPressed: () {
                          DiaryService().update(
                              currentUser,
                              _nameTextController.text,
                              _avatarUrlTextController.text,
                              context);
                          Future.delayed(Duration(milliseconds: 200))
                              .then((value) => Navigator.of(context).pop());
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
