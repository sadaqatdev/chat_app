import 'package:chat_app/pages/contact_view_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/chat_methods.dart';
import '../controllers/user_provider.dart';
import '../models/contact.dart';

class ChatListPage extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return StreamBuilder<QuerySnapshot>(
        // fetch all contact of current user
        stream: _chatMethods.fetchContacts(
          userId: userProvider.getUser?.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var docList = snapshot.data?.docs;

            if (docList?.isEmpty ?? false) {
              return const Center(
                  child: Text(
                "Empty chat!!",
              ));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: docList?.length,
              itemBuilder: (context, index) {
                // map data to Contact object conversion
                Contact contact = Contact.fromMap(
                    docList?[index].data() as Map<String, dynamic>);
                // we pass single contact object to [ContactView] page to disply the name and avatar of user
                return ContactView(
                  contact: contact,
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
