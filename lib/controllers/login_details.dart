// import 'package:chat_app/models/muser.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginDetails {
//   static String? userUid;
//   static bool? isUserActive;

//   SharedPreferences _preferences;

//   LoginDetails(this._preferences);

//   Future<bool> isLoginUser() async {
//     bool isLogin = _preferences.getBool('isLoginUser') ?? false;
//     if (isLogin == false) {
//       return false;
//     } else {
//       userUid = _preferences.getString('uid');

//       return true;
//     }
//   }

//   Future setUserData(MUser user) async {
//     LoginDetails.userUid = user.uid;
//     await _preferences.setString('uid', user.uid!);
//     await _preferences.setString('email', user.email!);
//     await _preferences.setString('name', user.name!);
//     await _preferences.setString('username', user.username!);
//     await _preferences.setString('profilePhoto', user.profilePhoto!);
//     await _preferences.reload();
//   }

//   Future<MUser> getUserData() async {
//     _preferences = await SharedPreferences.getInstance();
//     MUser user = MUser(
//       email: _preferences.getString('email'),
//       name: _preferences.getString('name'),
//       profilePhoto: _preferences.getString('profilePhoto'),
//       uid: _preferences.getString('uid'),
//       username: _preferences.getString('username'),
//     );
//     return user;
//   }
// }
