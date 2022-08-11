import 'package:chat_app/controllers/auth.dart';
import 'package:chat_app/utils/gloable_utils.dart';

import 'package:flutter/material.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  static String loginPageRoute = 'LoginPage';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Pagea")),
      body: SizedBox(
        width: getSize(context).width,
        height: getSize(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                sign();
              },
              child: const Text("Login with Google"),
            )
          ],
        ),
      ),
    );
  }

  // call google sing method here if isLogin return true it will go to home page else show error toast
  sign() {
    auth.sign().then((isLogin) {
      if (isLogin) {
        Navigator.pushReplacementNamed(context, HomePage.homePageRoute);
      } else {
        showToast(
            context: context,
            msg: "Error in login using google, please try again");
      }
    });
  }
}
