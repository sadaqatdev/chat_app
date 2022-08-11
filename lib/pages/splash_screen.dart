import 'package:chat_app/controllers/chat_methods.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class SpalashPage extends StatefulWidget {
  const SpalashPage({Key? key}) : super(key: key);

  @override
  State<SpalashPage> createState() => _SpalashPageState();
}

class _SpalashPageState extends State<SpalashPage> {
  ChatMethods methods = ChatMethods();

  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  // check user os login or not from firebase and action according to userDetails
  checkLogin() {
    methods.getUserDetails().then((userDetails) {
      if (userDetails != null) {
        Navigator.pushReplacementNamed(context, HomePage.homePageRoute);
      } else {
        Navigator.pushReplacementNamed(context, LoginPage.loginPageRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Wellcome to Chat app"),
      ),
    );
  }
}
