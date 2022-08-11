import 'package:flutter/widgets.dart';
import '../models/muser.dart';
import 'chat_methods.dart';

class UserProvider with ChangeNotifier {
  MUser? _user;

  ChatMethods methods = ChatMethods();

  MUser? get getUser => _user;
  // get current user details from firebse
  Future<void> refreshUser() async {
    MUser? user = await methods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
