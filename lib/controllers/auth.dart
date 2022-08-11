import 'package:chat_app/controllers/chat_methods.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/gloable_utils.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatMethods methods = ChatMethods();
  // here perform google sign with scope email
  Future<User?> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    dp(msg: "GoogleSing method call");
    try {
      GoogleSignInAccount? signInAccount = await googleSignIn.signIn();

      GoogleSignInAuthentication signInAuthentication =
          await signInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: signInAuthentication.accessToken,
          idToken: signInAuthentication.idToken);

      final UserCredential authResult =
          await _auth.signInWithCredential(credential).catchError((e) {
        dp(msg: "Error in sing", args: e);
      });
      final User? user = authResult.user;
      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      dp(msg: "Error in signin catch", args: e);
      return null;
    }
  }

  // call google sign method and it return User object based on this object condton we call authnticate method
  Future<bool> sign() async {
    try {
      User? googleUser = await googleSignIn();
      if (googleUser != null) {
        //
        await authenticateUser(googleUser);
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      dp(msg: "Error sign method ", args: e);
      return false;
    }
  }

  //add user data to firebase if not exits record
  Future authenticateUser(User user) async {
    var isNewUser = await methods.authenticateUser(user);
    if (isNewUser) {
      await methods.addDataToDb(user);
    }
  }
}
