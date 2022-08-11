import 'package:chat_app/controllers/chat_methods.dart';
import 'package:chat_app/models/contact.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';

import '../models/muser.dart';
import '../widgets/user_tile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final ChatMethods _authMethods = ChatMethods();

  ContactView({required this.contact});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MUser?>(
      // on basis of user uid we get details from user collection
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          MUser? user = snapshot.data;
          return InkWell(
              onTap: () {
                // go to Chat page and send receiver details to this page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChatPage(receiver: user!)));
              },
              // display the name and avatar of user fetch
              child: UserTile(user: user));
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
