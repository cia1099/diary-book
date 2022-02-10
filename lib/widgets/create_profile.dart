import 'package:flutter/material.dart';
import 'package:web_practice/model/user.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final MUser currentUser;

  @override
  Widget build(BuildContext context) {
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
                      backgroundImage: NetworkImage(currentUser.avatarUrl!),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: Container(
                                width: MediaQuery.of(context).size.width * 0.40,
                                height:
                                    MediaQuery.of(context).size.height * 0.40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Editing ${currentUser.name}',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
                                      child: Form(
                                        child: Column(
                                          children: [],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                  },
                ),
              ),
              Text(
                currentUser.name!,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          IconButton(
              onPressed: () {},
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
